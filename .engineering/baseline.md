# Brownfield audit — 2026-11-24

Both fresh source checkouts were clean. No existing AGENTS, OpenSpec or Beads store was found in either repository. Existing sources/workflows/tests were preserved. Work uses isolated `engineering/governance-bootstrap` branches. OpenSpec 1.15.0 and Beads 1.2.2 were executed; Beads initialized embedded Dolt and configured each existing GitHub repository as its Dolt Git remote. Database internals remain local. GitHub API returned `Branch not protected` for both main branches; no protection is claimed.

Upstream API resolved latest stable v26.3 (published 2026-09-28) and master 3863ab071ae08737c00832bfdd00c40279ad055a at audit time. These are observations, not new support claims. Existing configuration remains at v25.3. Future upgrades are tracked in `modernize-stellarium` and Beads, not implemented here.

## Mosaic at 33a279e017267c24b099f10e6650b700620d6c10

Source-observed: six patches extend root CMake and Oculars declarations, implementation, GUI panel and CMake; overlay supplies MosaicCamera resources and two Oculars Qt Test files. Oculars mosaic properties cover enable, panel counts, rotation and overlap. The implementation patch touches existing drawing/HUD and sensor paths, not just a new isolated feature. Correctness and unchanged behavior when disabled are unknown until differential regression runs.

Executed: `bash scripts/apply-patches.sh <isolated-upstream-v25.3>` passed all six checks, applied patches and copied overlay to upstream commit f9d9c26ac3aaea4e7d5fa9c76d9b8b87489f4bb0. Existing patch whitespace warnings were observed. No Stellarium compile or GUI run was performed.

Build CI actually validates patches and builds macOS (macos-14) and Windows (windows-latest), both with ENABLE_TESTING=OFF. It has no Ubuntu compilation job and no ctest step. Upstream-check workflow detects releases/master drift and creates GitHub issues; migrating work ownership to Beads is a later maintenance task. Release workflow creates a release job before packaging completes; promotion is not yet validated.

Test audit: patch 006 adds ADD_SUBDIRECTORY(test) under ENABLE_TESTING, but the resulting test directory has only testOcularsMosaic.cpp/.hpp, no CMakeLists.txt. Test scaffolding exercises setters/cache cases; its persistence test explicitly says it only verifies a setter. Neither buildability nor independent geometry/persistence coverage is established. Tests remain preserved, not disabled by this change.

Unknown: latest stable/master patch compatibility, Qt/toolchain reproducibility, true test discovery, existing Oculars regressions, independent spherical geometry, installed package and native GUI behavior on all platforms. Next: resolve stable/master and wire real tests while preserving these unknown labels.
