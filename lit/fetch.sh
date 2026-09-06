#!/bin/bash
# Fetch the arXiv HTML of the two KKX papers and extract plain text into lit/*.txt
# (kept out of git: these are third-party papers). Requires curl and python3.
cd "$(dirname "$0")"
extract() {
python3 - "$1" "$2" <<'PY'
import re, html, sys
s = open(sys.argv[1], encoding="utf-8").read()
s = re.sub(r'<math[^>]*alttext="([^"]*)"[^>]*>.*?</math>', lambda m: ' $' + html.unescape(m.group(1)) + '$ ', s, flags=re.S)
s = re.sub(r'<script.*?</script>|<style.*?</style>', '', s, flags=re.S)
s = html.unescape(re.sub(r'<[^>]+>', '', s))
s = re.sub(r'\n\s*\n+', '\n', re.sub(r'[ \t]+', ' ', s))
open(sys.argv[2], "w").write(s)
PY
}
curl -sL https://arxiv.org/html/2504.14711 -o /tmp/kkx-survey.html && extract /tmp/kkx-survey.html KKX2025-survey-arXiv2504.14711.txt
curl -sL https://arxiv.org/html/2411.08372 -o /tmp/kkx-sparse.html && extract /tmp/kkx-sparse.html KKX2024-sparse-arXiv2411.08372.txt
ls -la *.txt
