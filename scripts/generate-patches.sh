#!/bin/bash
# Generate patches from stellarium fork against upstream version
set -e

UPSTREAM_TAG="${1:-v25.4}"
STELLARIUM_DIR="${2:-../stellarium}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PATCHES_DIR="$REPO_ROOT/patches"

cd "$STELLARIUM_DIR"

echo "Generating patches against $UPSTREAM_TAG..."

# Find merge base with upstream
if ! BASE=$(git merge-base master upstream/master 2>/dev/null); then
    echo "Warning: Could not find merge-base with upstream/master, using tag directly"
    BASE="$UPSTREAM_TAG"
fi

echo "Using base commit: $BASE"

# Generate patches
git diff "$BASE..master" -- CMakeLists.txt > "$PATCHES_DIR/001-cmakelists-add-mosaiccamera.patch"
git diff "$BASE..master" -- plugins/Oculars/src/Oculars.hpp > "$PATCHES_DIR/002-oculars-hpp-mosaic-properties.patch"
git diff "$BASE..master" -- plugins/Oculars/src/Oculars.cpp > "$PATCHES_DIR/003-oculars-cpp-mosaic-implementation.patch"
git diff "$BASE..master" -- plugins/Oculars/src/gui/OcularsGuiPanel.hpp > "$PATCHES_DIR/004-oculars-guipanel-hpp.patch"
git diff "$BASE..master" -- plugins/Oculars/src/gui/OcularsGuiPanel.cpp > "$PATCHES_DIR/005-oculars-guipanel-cpp.patch"
git diff "$BASE..master" -- plugins/Oculars/src/CMakeLists.txt > "$PATCHES_DIR/006-oculars-cmakelists-tests.patch"

echo "Patches generated successfully:"
ls -lh "$PATCHES_DIR"/*.patch
