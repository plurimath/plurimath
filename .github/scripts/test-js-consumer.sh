#!/usr/bin/env bash
set -euo pipefail

# The downstream build mounts only its checkout into the container and adds
# vendor/plurimath/lib explicitly. Test this PR, rather than that old gitlink.
source_revision=$(git -C .. rev-parse HEAD)
git -C vendor/plurimath fetch --depth 1 ../../.. "$source_revision"
git -C vendor/plurimath checkout --detach FETCH_HEAD
git update-index --cacheinfo "160000,$source_revision,vendor/plurimath"
test "$(git -C vendor/plurimath rev-parse HEAD)" = "$source_revision"
echo "JS consumer Plurimath source: $source_revision"

python3 - <<'PY'
from pathlib import Path
import re

# setup.sh runs inside the container, so both paths and the backend choice
# must survive there. Opal uses the pure-Ruby parser and needs no Rust build.
gemfile = Path("Gemfile")
lines = gemfile.read_text().splitlines()
declaration = re.compile(r'''^\s*gem\s+["'](?:plurimath|parsanol|amath)["']''')
lines = [line for line in lines if not declaration.match(line)]
backend = next(line for line in Path("../Gemfile").read_text().splitlines()
               if re.match(r'''^gem\s+["']parsanol["']''', line))
asciimath = next(line.strip() for line in Path("../Gemfile").read_text().splitlines()
                 if re.match(r'''^\s*gem\s+["']amath["']''', line) and "github:" in line)
# Use Opal's sequential scheduler for this isolated integration build.
lines += ['ENV["PARSANOL_PURE_RUBY"] = "1"',
          'ENV["OPAL_PREFORK_DISABLE"] = "1"',
          'gem "plurimath", path: "vendor/plurimath"', backend, asciimath]
gemfile.write_text("\n".join(lines) + "\n")
PY

timeout --kill-after=15s 15m npm run build
timeout --kill-after=15s 5m npx --no-install jest --runInBand
