#!/usr/bin/env python3
"""Infer field-level schema from captured API payloads.

Reads capture files produced by /capture (see CLAUDE.md for the file schema), walks
every JSON path in every request and response body, and reports what was actually
observed: types, null rate, cardinality, detected formats, and samples.

The point is corpus-wide inference. A field that is a string in 40 responses and null
in one is nullable, and you will not notice that by reading payloads one at a time.

Usage:
    python3 scripts/infer_schema.py raw/network --out docs/02-data-model/observed-fields.md
    python3 scripts/infer_schema.py raw/network --format json
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from pathlib import Path

MAX_DISTINCT = 40          # stop tracking distinct values past this; treat as free-form
MAX_SAMPLES = 3
ENUM_THRESHOLD = 12        # at or below this many distinct values, call it a probable enum

UUID_RE = re.compile(r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", re.I)
ISO_RE = re.compile(r"^\d{4}-\d{2}-\d{2}([T ]\d{2}:\d{2}(:\d{2})?(\.\d+)?(Z|[+-]\d{2}:?\d{2})?)?$")
EMAIL_RE = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
URL_RE = re.compile(r"^https?://")
HEXID_RE = re.compile(r"^[0-9a-f]{16,}$", re.I)
NUMERIC_RE = re.compile(r"^\d+$")


class FieldStats:
    __slots__ = ("types", "n", "nulls", "distinct", "overflow", "samples", "min_len", "max_len")

    def __init__(self) -> None:
        self.types: set[str] = set()
        self.n = 0
        self.nulls = 0
        self.distinct: set = set()
        self.overflow = False
        self.samples: list = []
        self.min_len: int | None = None
        self.max_len: int | None = None

    def observe(self, value) -> None:
        self.n += 1
        if value is None:
            self.nulls += 1
            self.types.add("null")
            return
        self.types.add(json_type(value))
        if isinstance(value, str):
            n = len(value)
            self.min_len = n if self.min_len is None else min(self.min_len, n)
            self.max_len = n if self.max_len is None else max(self.max_len, n)
        if isinstance(value, (str, int, float, bool)):
            if not self.overflow:
                self.distinct.add(value)
                if len(self.distinct) > MAX_DISTINCT:
                    self.overflow = True
                    self.distinct.clear()
            if len(self.samples) < MAX_SAMPLES and value not in self.samples:
                self.samples.append(value)

    @property
    def nullable(self) -> bool:
        return self.nulls > 0

    def type_label(self) -> str:
        concrete = sorted(t for t in self.types if t != "null")
        if not concrete:
            return "null (always)"
        label = " or ".join(concrete)
        return label + ("?" if self.nullable else "")

    def format_hint(self) -> str:
        strings = [v for v in (self.samples or list(self.distinct)[:MAX_SAMPLES]) if isinstance(v, str)]
        if not strings:
            return ""
        for name, rx in (("uuid", UUID_RE), ("iso-8601", ISO_RE), ("email", EMAIL_RE),
                         ("url", URL_RE), ("hex-id", HEXID_RE), ("numeric-string", NUMERIC_RE)):
            if all(rx.match(s) for s in strings):
                return name
        if self.n >= 3 and self.min_len is not None and self.min_len == self.max_len:
            return f"fixed len {self.min_len}"
        return ""

    def enum_values(self) -> list | None:
        if self.overflow or not self.distinct:
            return None
        if any(t not in ("string", "integer", "boolean") for t in self.types if t != "null"):
            return None
        if len(self.distinct) > ENUM_THRESHOLD:
            return None
        if self.n < 3 or len(self.distinct) >= self.n - self.nulls:
            return None  # every value unique so far: identifier or free text, not an enum
        return sorted(self.distinct, key=lambda v: (type(v).__name__, v))


def json_type(value) -> str:
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "boolean"
    if isinstance(value, int):
        return "integer"
    if isinstance(value, float):
        return "number"
    if isinstance(value, str):
        return "string"
    if isinstance(value, list):
        return "array"
    if isinstance(value, dict):
        return "object"
    return type(value).__name__


def normalize_path(url: str) -> str:
    """Collapse identifier-looking path segments so instances of a route group together."""
    path = re.sub(r"^https?://[^/]+", "", url).split("?", 1)[0].split("#", 1)[0]
    out = []
    for seg in path.split("/"):
        if not seg:
            continue
        if NUMERIC_RE.match(seg) or UUID_RE.match(seg) or HEXID_RE.match(seg):
            out.append(":id")
        else:
            out.append(seg)
    return "/" + "/".join(out)


def walk(node, prefix: str, sink: dict[str, FieldStats]) -> None:
    """Record every leaf path. Array elements merge into a single `[]` path."""
    if isinstance(node, dict):
        for key, value in node.items():
            child = f"{prefix}.{key}" if prefix else key
            if isinstance(value, (dict, list)):
                sink[child].observe(value)
                walk(value, child, sink)
            else:
                sink[child].observe(value)
    elif isinstance(node, list):
        child = f"{prefix}[]"
        for item in node:
            if isinstance(item, (dict, list)):
                walk(item, child, sink)
            else:
                sink[child].observe(item)


def looks_like_fk(field_path: str) -> bool:
    leaf = field_path.split(".")[-1].removesuffix("[]")
    return leaf == "id" or leaf.endswith("_id") or (leaf.endswith("Id") and leaf != "Id")


def load_captures(root: Path) -> tuple[list[dict], list[str]]:
    captures, problems = [], []
    for path in sorted(root.rglob("*.json")):
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, UnicodeDecodeError) as exc:
            problems.append(f"{path}: {exc}")
            continue
        for entry in data if isinstance(data, list) else [data]:
            if isinstance(entry, dict):
                entry.setdefault("_source", str(path))
                captures.append(entry)
            else:
                problems.append(f"{path}: top level is {json_type(entry)}, expected object or array")
    return captures, problems


def build(captures: list[dict]) -> dict:
    endpoints: dict[tuple, dict] = defaultdict(
        lambda: {"fields": defaultdict(FieldStats), "req_fields": defaultdict(FieldStats),
                 "count": 0, "statuses": defaultdict(int), "sources": set(),
                 "pages": set(), "query_params": set()}
    )
    for cap in captures:
        url = cap.get("url", "")
        method = (cap.get("method") or "GET").upper()
        key = (method, normalize_path(url))
        ep = endpoints[key]
        ep["count"] += 1
        ep["statuses"][cap.get("status", "?")] += 1
        ep["sources"].add(cap.get("_source", ""))
        if cap.get("page_slug"):
            ep["pages"].add(cap["page_slug"])
        if "?" in url:
            for part in url.split("?", 1)[1].split("&"):
                if part:
                    ep["query_params"].add(part.split("=", 1)[0])
        body = cap.get("response_body")
        if body is not None:
            walk(body, "", ep["fields"])
        req = cap.get("request_body")
        if isinstance(req, (dict, list)):
            walk(req, "", ep["req_fields"])
    return endpoints


def render_table(fields: dict[str, FieldStats]) -> list[str]:
    lines = ["| field | type | null | distinct | format | samples / enum |",
             "|---|---|---|---|---|---|"]
    for name in sorted(fields):
        st = fields[name]
        if st.types <= {"object", "array"} and not st.nullable:
            continue  # container, its leaves are listed separately
        enum = st.enum_values()
        if enum is not None and len(enum) > 1:
            detail = "enum: " + ", ".join(f"`{v}`" for v in enum)
        else:
            detail = ", ".join(f"`{s}`" for s in st.samples) if st.samples else ""
        distinct = "many" if st.overflow else (str(len(st.distinct)) if st.distinct else "-")
        null_pct = f"{100 * st.nulls / st.n:.0f}%" if st.n else "-"
        flag = " **FK?**" if looks_like_fk(name) else ""
        lines.append(
            f"| `{name}`{flag} | {st.type_label()} | {null_pct} | {distinct} | "
            f"{st.format_hint()} | {detail} |"
        )
    lines.append("")
    return lines


def render(endpoints: dict, problems: list[str]) -> str:
    out = ["# Observed fields", "",
           "Generated by `scripts/infer_schema.py` from the capture corpus. Every row is",
           "`[observed]`. Regenerate after each capture round; do not hand-edit.", "",
           f"**{len(endpoints)} distinct endpoints.**", ""]
    if problems:
        out += ["## Unreadable captures", ""] + [f"- {p}" for p in problems] + [""]
    for (method, path) in sorted(endpoints):
        ep = endpoints[(method, path)]
        statuses = ", ".join(f"{k} ×{v}" for k, v in sorted(ep["statuses"].items(), key=str))
        out += [f"## `{method} {path}`", "",
                f"- observations: {ep['count']} | statuses: {statuses}",
                f"- seen on pages: {', '.join(sorted(ep['pages'])) or 'unrecorded'}"]
        if ep["query_params"]:
            out.append(f"- query params: {', '.join('`%s`' % q for q in sorted(ep['query_params']))}")
        out.append("")
        if ep["req_fields"]:
            out += ["### Request body", ""] + render_table(ep["req_fields"])
        if ep["fields"]:
            out += ["### Response body", ""] + render_table(ep["fields"])
        else:
            out += ["_No structured response body captured._", ""]
    return "\n".join(out) + "\n"


def to_json(endpoints: dict) -> str:
    payload = {}
    for (method, path), ep in sorted(endpoints.items()):
        payload[f"{method} {path}"] = {
            "observations": ep["count"],
            "statuses": {str(k): v for k, v in ep["statuses"].items()},
            "pages": sorted(ep["pages"]),
            "query_params": sorted(ep["query_params"]),
            "response_fields": {
                name: {"types": sorted(st.types), "nullable": st.nullable,
                       "observations": st.n, "nulls": st.nulls,
                       "distinct": None if st.overflow else len(st.distinct),
                       "format": st.format_hint() or None,
                       "enum": st.enum_values(), "samples": st.samples}
                for name, st in sorted(ep["fields"].items())
            },
        }
    return json.dumps(payload, indent=2, default=str)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("root", type=Path, help="directory of capture files (recursed)")
    ap.add_argument("--out", type=Path, help="write here instead of stdout")
    ap.add_argument("--format", choices=("markdown", "json"), default="markdown")
    args = ap.parse_args()

    if not args.root.is_dir():
        print(f"error: {args.root} is not a directory", file=sys.stderr)
        return 2

    captures, problems = load_captures(args.root)
    if not captures:
        print(f"error: no usable capture files found under {args.root}", file=sys.stderr)
        for problem in problems:
            print(f"  unreadable: {problem}", file=sys.stderr)
        return 1

    endpoints = build(captures)
    text = render(endpoints, problems) if args.format == "markdown" else to_json(endpoints)

    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text, encoding="utf-8")
        print(f"{len(captures)} captures, {len(endpoints)} endpoints -> {args.out}", file=sys.stderr)
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
