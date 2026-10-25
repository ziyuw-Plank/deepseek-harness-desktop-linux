#!/bin/bash
set -euo pipefail
export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"
exec zypak-wrapper /app/extra/deepseek-harness/deepseek-harness "$@"
