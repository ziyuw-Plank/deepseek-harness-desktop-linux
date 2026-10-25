#!/bin/bash
set -euo pipefail
# Extract unsigned .deb (VS Code-style). Runs inside Flatpak apply_extra sandbox.
ar x deepseek-harness.deb
tar xf data.tar.*
rm -f deepseek-harness.deb control.tar.* data.tar.* debian-binary
mv opt/deepseek-harness deepseek-harness
rm -rf opt usr
