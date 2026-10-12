#!/usr/bin/env python3
"""Extract schema evidence from saved HTML pages of a server-rendered app.

For a PHP-style app there is no JSON API to read, so the schema evidence lives in the
markup: form field names are close to column names, select options are enums, table
headers are query projections, and query-string parameters are the filter vocabulary.

This walks saved .html files and reports all four, aggregated across every page, so you
can see the whole vocabulary at once instead of one page at a time.

Standard library only, so it runs anywhere without installing anything.

Usage:
    python3 scripts/extract_structure.py raw/pages --out docs/03-api/observed-structure.md
    python3 scripts/extract_structure.py raw/pages --format json
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import parse_qs, urlsplit

SKIP_FIELD_TYPES = {"submit", "button", "image", "reset"}
# Hidden fields carry CSRF tokens and session values. Their names are useful evidence;
# their values are secrets and must never reach docs/.
SECRET_NAME = re.compile(r"csrf|token|nonce|secret|session|auth|key|sig|hash", re.I)
ID_SEGMENT = re.compile(r"^\d+$|^[0-9a-f]{8,}$", re.I)


def redact(name: str, value: str) -> str:
    """Keep short, meaningful hidden values (ids, flags); mask anything secret-looking."""
    if not value:
        return ""
    if SECRET_NAME.search(name) or len(value) > 24:
        return "<redacted>"
    return value


class Extractor(HTMLParser):
    """Pulls forms, tables, and links out of one page."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.forms: list[dict] = []
        self.tables: list[dict] = []
        self.links: list[str] = []
        self._form: dict | None = None
        self._select: dict | None = None
        self._in_option = False
        self._option_buf: list[str] = []
        self._option_attrs: dict = {}
        self._table_stack: list[dict] = []
        self._in_th = False
        self._th_buf: list[str] = []
        self._heading_buf: list[str] = []
        self._in_heading = False
        self._last_heading = ""

    # -- helpers ----------------------------------------------------------
    @staticmethod
    def _attrs(pairs) -> dict:
        return {k.lower(): (v if v is not None else "") for k, v in pairs}

    # -- tags -------------------------------------------------------------
    def handle_starttag(self, tag, attrs):
        a = self._attrs(attrs)
        tag = tag.lower()

        if tag == "form":
            self._form = {"action": a.get("action", ""), "method": a.get("method", "get").upper(),
                          "id": a.get("id") or a.get("name") or "", "fields": []}
        elif tag in ("input", "textarea") and self._form is not None:
            ftype = a.get("type", "text" if tag == "input" else "textarea").lower()
            if ftype in SKIP_FIELD_TYPES or not a.get("name"):
                return
            self._form["fields"].append({
                "name": a["name"], "type": ftype,
                "required": "required" in a, "maxlength": a.get("maxlength", ""),
                "pattern": a.get("pattern", ""),
                "value": redact(a["name"], a.get("value", "")) if ftype == "hidden" else "",
                "options": [],
            })
        elif tag == "select" and self._form is not None and a.get("name"):
            self._select = {"name": a["name"], "type": "select",
                            "required": "required" in a, "maxlength": "", "pattern": "",
                            "value": "", "options": []}
        elif tag == "option" and self._select is not None:
            self._in_option = True
            self._option_buf = []
            self._option_attrs = a
        elif tag == "table":
            self._table_stack.append({"headers": [], "rows": 0, "near": self._last_heading})
        elif tag == "tr" and self._table_stack:
            self._table_stack[-1]["rows"] += 1
        elif tag == "th" and self._table_stack:
            self._in_th, self._th_buf = True, []
        elif tag == "a" and a.get("href"):
            self.links.append(a["href"])
        elif tag in ("h1", "h2", "h3", "legend", "caption"):
            self._in_heading, self._heading_buf = True, []

    def handle_endtag(self, tag):
        tag = tag.lower()
        if tag == "form" and self._form is not None:
            self.forms.append(self._form)
            self._form = None
        elif tag == "select" and self._select is not None:
            if self._form is not None:
                self._form["fields"].append(self._select)
            self._select = None
        elif tag == "option" and self._in_option:
            label = " ".join("".join(self._option_buf).split())
            value = self._option_attrs.get("value", label)
            if self._select is not None and (value or label):
                self._select["options"].append({"value": value, "label": label})
            self._in_option = False
        elif tag == "th" and self._in_th:
            text = " ".join("".join(self._th_buf).split())
            if text and self._table_stack:
                self._table_stack[-1]["headers"].append(text)
            self._in_th = False
        elif tag == "table" and self._table_stack:
            self.tables.append(self._table_stack.pop())
        elif tag in ("h1", "h2", "h3", "legend", "caption") and self._in_heading:
            self._last_heading = " ".join("".join(self._heading_buf).split())[:80]
            self._in_heading = False

    def handle_data(self, data):
        if self._in_option:
            self._option_buf.append(data)
        if self._in_th:
            self._th_buf.append(data)
        if self._in_heading:
            self._heading_buf.append(data)


def route_pattern(href: str) -> tuple[str, list[str]]:
    """Return (path with id-ish segments collapsed, query parameter names)."""
    parts = urlsplit(href)
    if parts.scheme in ("mailto", "javascript", "tel"):
        return "", []
    segs = ["<id>" if ID_SEGMENT.match(s) else s for s in parts.path.split("/") if s]
    path = "/" + "/".join(segs)
    return path, sorted(parse_qs(parts.query).keys())


def analyze(root: Path) -> dict:
    pages = sorted(p for p in root.rglob("*") if p.suffix.lower() in (".html", ".htm"))
    forms_by_action: dict[str, dict] = {}
    fields: dict[str, dict] = defaultdict(
        lambda: {"types": set(), "required_in": 0, "seen": 0, "options": {}, "pages": set(), "maxlength": set()})
    tables: list[dict] = []
    routes: dict[str, set] = defaultdict(set)

    for page in pages:
        ex = Extractor()
        try:
            ex.feed(page.read_text(encoding="utf-8", errors="replace"))
        except Exception as exc:                      # malformed markup should not stop the run
            print(f"warning: {page}: {exc}", file=sys.stderr)
            continue
        slug = page.stem

        for form in ex.forms:
            key = f"{form['method']} {route_pattern(form['action'])[0] or '(self)'}"
            entry = forms_by_action.setdefault(
                key, {"method": form["method"], "action": form["action"], "pages": set(), "fields": {}})
            entry["pages"].add(slug)
            for f in form["fields"]:
                entry["fields"][f["name"]] = f
                agg = fields[f["name"]]
                agg["seen"] += 1
                agg["types"].add(f["type"])
                agg["pages"].add(slug)
                if f["required"]:
                    agg["required_in"] += 1
                if f["maxlength"]:
                    agg["maxlength"].add(f["maxlength"])
                for opt in f["options"]:
                    if opt["value"] not in ("", None):
                        agg["options"][opt["value"]] = opt["label"]

        for t in ex.tables:
            if t["headers"]:
                tables.append({"page": slug, "near": t["near"],
                               "headers": t["headers"], "rows": max(0, t["rows"] - 1)})

        for href in ex.links:
            path, params = route_pattern(href)
            if path:
                routes[path].update(params)

    return {"pages": len(pages), "forms": forms_by_action, "fields": fields,
            "tables": tables, "routes": routes}


def render(data: dict) -> str:
    out = ["# Observed structure", "",
           "Generated by `scripts/extract_structure.py` from saved HTML. Every row is",
           "`[observed]`. In a server-rendered app these form field names are the closest",
           "thing to column names you will get without database access.", "",
           f"Pages parsed: {data['pages']} | forms: {len(data['forms'])} | "
           f"distinct field names: {len(data['fields'])} | routes: {len(data['routes'])}", ""]

    out += ["## Field vocabulary", "",
            "Aggregated across every form on every page. Options are enums; take them seriously.", "",
            "| field | types | required | maxlen | pages | options |", "|---|---|---|---|---|---|"]
    for name in sorted(data["fields"]):
        f = data["fields"][name]
        opts = ", ".join(
            f"`{v}`" + (f" ({lbl})" if lbl and lbl != v else "")
            for v, lbl in list(f["options"].items())[:12])
        if len(f["options"]) > 12:
            opts += f" (+{len(f['options']) - 12} more)"
        req = f"{f['required_in']}/{f['seen']}"
        out.append(f"| `{name}` | {', '.join(sorted(f['types']))} | {req} | "
                   f"{', '.join(sorted(f['maxlength'])) or '-'} | {len(f['pages'])} | {opts} |")
    out.append("")

    out += ["## Forms", ""]
    for key in sorted(data["forms"]):
        form = data["forms"][key]
        out += [f"### `{key}`", "",
                f"- action: `{form['action'] or '(self)'}`",
                f"- seen on: {', '.join(sorted(form['pages']))}", "",
                "| field | type | required | hidden value |", "|---|---|---|---|"]
        for fname in sorted(form["fields"]):
            f = form["fields"][fname]
            out.append(f"| `{fname}` | {f['type']} | {'yes' if f['required'] else ''} | "
                       f"{('`%s`' % f['value']) if f['value'] else ''} |")
        out.append("")

    out += ["## Table columns", "",
            "List-page headers are usually a direct projection of a query.", ""]
    for t in sorted(data["tables"], key=lambda x: (x["page"], x["near"])):
        out.append(f"- **{t['page']}**{(' / ' + t['near']) if t['near'] else ''} "
                   f"({t['rows']} rows): {', '.join(t['headers'])}")
    out.append("")

    out += ["## Routes and query parameters", "",
            "Query parameter names are the filter and sort vocabulary.", "",
            "| route | params |", "|---|---|"]
    for path in sorted(data["routes"]):
        params = ", ".join(f"`{p}`" for p in sorted(data["routes"][path]))
        out.append(f"| `{path}` | {params} |")
    return "\n".join(out) + "\n"


def to_json(data: dict) -> str:
    return json.dumps({
        "pages_parsed": data["pages"],
        "fields": {n: {"types": sorted(f["types"]), "required_in": f["required_in"],
                       "seen": f["seen"], "maxlength": sorted(f["maxlength"]),
                       "options": f["options"], "pages": sorted(f["pages"])}
                   for n, f in sorted(data["fields"].items())},
        "forms": {k: {"method": v["method"], "action": v["action"],
                      "pages": sorted(v["pages"]), "fields": v["fields"]}
                  for k, v in sorted(data["forms"].items())},
        "tables": data["tables"],
        "routes": {k: sorted(v) for k, v in sorted(data["routes"].items())},
    }, indent=2)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("root", type=Path, help="directory of saved .html pages (recursed)")
    ap.add_argument("--out", type=Path)
    ap.add_argument("--format", choices=("markdown", "json"), default="markdown")
    args = ap.parse_args()

    if not args.root.is_dir():
        print(f"error: {args.root} is not a directory", file=sys.stderr)
        return 2

    data = analyze(args.root)
    if not data["pages"]:
        print(f"error: no .html files found under {args.root}", file=sys.stderr)
        return 1

    text = render(data) if args.format == "markdown" else to_json(data)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text, encoding="utf-8")
        print(f"{data['pages']} pages, {len(data['fields'])} fields -> {args.out}", file=sys.stderr)
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
