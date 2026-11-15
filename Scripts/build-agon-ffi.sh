#!/bin/bash
set -euo pipefail

export PATH="$HOME/.cargo/bin:$PATH"

if [[ "$(uname -m)" != "arm64" ]]; then
    echo "error: agon-ctl's macOS backend requires an Apple Silicon Mac." >&2
    exit 1
fi

export CARGO_TARGET_DIR="${SRCROOT}/Vendor/agon-ctl/target"
cargo build --manifest-path "${SRCROOT}/Vendor/agon-ctl/Cargo.toml" -p agon-osd-ffi --profile ffi --locked
