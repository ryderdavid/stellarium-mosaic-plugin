#!/bin/bash
# Apply patches and overlay files to a clean Stellarium checkout
set -e

STELLARIUM_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PATCHES_DIR="$REPO_ROOT/patches"
OVERLAY_DIR="$REPO_ROOT/overlay"

echo "Applying patches to $STELLARIUM_DIR..."

# Check if patches apply cleanly first
for patch in "$PATCHES_DIR"/*.patch; do
    if [ ! -s "$patch" ]; then
        echo "Warning: $(basename "$patch") is empty, skipping"
        continue
    fi

    echo "Checking $(basename "$patch")..."
    if ! git -C "$STELLARIUM_DIR" apply --check "$patch" 2>&1; then
        echo "ERROR: $(basename "$patch") fails to apply!"
        exit 1
    fi
done

# Apply patches
for patch in "$PATCHES_DIR"/*.patch; do
    if [ ! -s "$patch" ]; then
        continue
    fi

    echo "Applying $(basename "$patch")..."
    git -C "$STELLARIUM_DIR" apply "$patch"
done

# Copy overlay files
echo "Copying overlay files..."
if [ -d "$OVERLAY_DIR" ]; then
    cp -r "$OVERLAY_DIR"/* "$STELLARIUM_DIR/"
    echo "Overlay files copied successfully"
else
    echo "Warning: No overlay directory found"
fi

echo "All patches and overlays applied successfully!"
