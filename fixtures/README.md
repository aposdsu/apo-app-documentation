# Fixtures

Three synthetic capture files in the exact format `/capture` produces. They are invented,
not from any real platform, and exist so you can run `scripts/infer_schema.py` and see
its output before you have captured anything:

```
python3 scripts/infer_schema.py fixtures/network
```

They also serve as the reference for the capture file format. Delete this folder once
real captures exist, or keep it as a regression check on the script.
