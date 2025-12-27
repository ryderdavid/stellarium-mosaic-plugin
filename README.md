# Stellarium Mosaic Planning Plugin

This repository maintains the **Mosaic Planning Plugin** for Stellarium as a set of patches and overlay files that can be applied to upstream Stellarium releases. The plugin extends the Oculars plugin with mosaic planning capabilities similar to NINA's framing assistant or Telescopius's telescope simulator.

**Current Release**: `upstream.25.3_mosaicplugin.0.5.0`

### Platform Support

| Platform | Status | Download |
|----------|--------|----------|
| **macOS** (Apple Silicon) | ✅ Supported | DMG installer |
| **Windows** (x64) | ✅ Supported | EXE installer |
| **Linux** (x86_64) | ⚠️ Build from source | AppImage planned |

## Features

- **N×M Mosaic Grid**: Configure any grid size (e.g., 3×3, 5×7, etc.)
- **Adjustable Overlap**: Set overlap percentage between adjacent panels (0-50%)
- **Rotation Control**: Rotate the entire mosaic grid to any angle
- **Real-time Visualization**: See all mosaic panels overlaid on the sky
- **Equipment Integration**: Uses existing Oculars equipment data (CCD, Telescope, Lens)
- **HUD Display**: Heads-up display showing mosaic configuration and coverage

## Architecture

This repository uses a **patch-based approach** to maintain compatibility with upstream Stellarium:

```
stellarium-mosaic-plugin/
├── patches/              # Git patches for upstream modifications
├── overlay/              # New files to copy into Stellarium
├── scripts/              # Helper scripts for applying/generating patches
├── config/               # Configuration (target Stellarium version)
└── .github/workflows/    # CI/CD automation
```

### Why Patches?

- **Upstream Compatibility**: Easily track and update as Stellarium evolves
- **Minimal Maintenance**: Patches clearly show what changed from vanilla Stellarium
- **CI/CD Integration**: Automated testing against upstream releases
- **Clean Separation**: New plugin code in overlay, modifications in patches

## Installation

### Option 1: Download Pre-built Release

1. Go to [Releases](../../releases)
2. Download for your platform:
   - **macOS**: `Stellarium-Mosaic-*-arm64.dmg` (Apple Silicon)
   - **Windows**: `stellarium-*-qt6-win64.exe` (installer)
   - **Linux**: Not yet available (build from source - see below)
3. Install and run the downloaded application

### Option 2: Build from Source

#### Prerequisites

- Git
- CMake 3.16+
- Qt 5.15+ or Qt 6.x
- C++17 compatible compiler
- Stellarium build dependencies (see [Stellarium build docs](https://github.com/Stellarium/stellarium/blob/master/BUILDING.md))

#### Build Steps

```bash
# 1. Clone this repository
git clone https://github.com/YOUR_USERNAME/stellarium-mosaic-plugin.git
cd stellarium-mosaic-plugin

# 2. Clone Stellarium at the target version
STELLARIUM_VERSION=$(cat config/stellarium-version.txt)
git clone --branch $STELLARIUM_VERSION --recurse-submodules https://github.com/Stellarium/stellarium.git

# 3. Apply patches and overlay
bash scripts/apply-patches.sh stellarium

# 4. Build Stellarium
cd stellarium
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel

# 5. Run
./build/src/stellarium
```

## Usage

Once installed:

1. **Enable Mosaic Mode**:
   - Open Oculars plugin (default: `Ctrl+O`)
   - Select a CCD sensor configuration
   - Enable mosaic mode via the GUI panel

2. **Configure Mosaic**:
   - Set panel count (X and Y axes)
   - Adjust overlap percentage
   - Rotate the mosaic grid
   - View real-time updates on screen

3. **HUD Information**:
   - Total coverage area
   - Panel count and configuration
   - Current camera/telescope/lens setup

## Development

### Architecture: No Fork Required

This repository uses a **patch-based approach** that works directly with upstream Stellarium:

**For building/using:**
```bash
git clone https://github.com/Stellarium/stellarium.git  # Upstream directly
bash apply-patches.sh stellarium                        # Apply our patches
cd stellarium && cmake -B build && cmake --build build  # Build
```

**For development:**
You have two options:
1. **Work on a Stellarium fork** (easier for large changes)
2. **Modify a local Stellarium clone directly** (simpler for small changes)

Either way, you use `generate-patches.sh` to extract your changes as patch files.

### Repository Structure

#### Patches (`patches/`)

Modifications to upstream Stellarium files:

- `001-cmakelists-add-mosaiccamera.patch` - Add MosaicCamera plugin to build
- `002-oculars-hpp-mosaic-properties.patch` - Mosaic properties in Oculars.hpp
- `003-oculars-cpp-mosaic-implementation.patch` - Core mosaic implementation
- `004-oculars-guipanel-hpp.patch` - GUI panel declarations
- `005-oculars-guipanel-cpp.patch` - GUI panel implementation
- `006-oculars-cmakelists-tests.patch` - Test configuration

#### Overlay (`overlay/`)

New files added to Stellarium:

- `plugins/MosaicCamera/` - Complete MosaicCamera plugin
- `plugins/Oculars/src/test/` - Mosaic unit tests

### Scripts

#### `scripts/generate-patches.sh`

Extracts your changes as patches from a modified Stellarium directory:

```bash
# From stellarium-mosaic-plugin directory
bash scripts/generate-patches.sh v25.4 /path/to/modified/stellarium
```

**Prerequisites:**
The Stellarium directory must have:
- An `upstream` remote pointing to `Stellarium/stellarium`
- Your changes on the `master` branch

**When to use:**
- After making changes to Stellarium
- When updating to a new Stellarium version
- When patches fail to apply and need manual fixes

#### `scripts/apply-patches.sh`

Applies patches and overlay to a clean Stellarium checkout:

```bash
# From stellarium-mosaic-plugin directory
bash scripts/apply-patches.sh /path/to/stellarium
```

**When to use:**
- Building from source
- Testing patches
- CI/CD workflows

### Updating to a New Stellarium Version

1. **Update configuration**:
   ```bash
   echo "v25.5" > config/stellarium-version.txt
   ```

2. **Get a Stellarium directory with your changes**:

   **Option A: Using a fork**
   ```bash
   cd /path/to/your/stellarium/fork
   git fetch upstream
   git checkout master
   git rebase upstream/v25.5  # or merge
   ```

   **Option B: Modifying a fresh clone**
   ```bash
   git clone --branch v25.5 https://github.com/Stellarium/stellarium.git stellarium-work
   cd stellarium-work
   git remote add upstream https://github.com/Stellarium/stellarium.git
   # Manually apply your changes or try to apply old patches:
   bash /path/to/stellarium-mosaic-plugin/scripts/apply-patches.sh .
   # Fix any conflicts, test changes
   git add . && git commit -m "Apply mosaic plugin changes"
   ```

3. **Regenerate patches**:
   ```bash
   cd /path/to/stellarium-mosaic-plugin
   bash scripts/generate-patches.sh v25.5 /path/to/stellarium-work
   ```

4. **Test the new patches**:
   ```bash
   # Apply to clean checkout
   git clone --branch v25.5 https://github.com/Stellarium/stellarium.git stellarium-test
   bash scripts/apply-patches.sh stellarium-test
   cd stellarium-test
   cmake -B build && cmake --build build
   ```

5. **Commit and tag**:
   ```bash
   git add config/stellarium-version.txt patches/
   git commit -m "Update to Stellarium v25.5"
   git push
   git tag upstream.25.5_mosaicplugin.X.Y.Z
   git push --tags
   ```

## CI/CD

This repository uses GitHub Actions for automated testing and releases.

### Workflows

#### `build.yml` - Main Build
- **Triggers**: Push to main, pull requests
- **Jobs**:
  - Validate patches apply cleanly
  - Build on Linux (Qt6)
  - Build on macOS (Apple Silicon)
  - Build on Windows (Qt6)
  - Run tests

#### `release.yml` - Release Build
- **Triggers**: Tag push (`v*`)
- **Artifacts**:
  - macOS DMG (arm64, Apple Silicon)
  - Windows Installer (.exe, x64)
  - Linux builds: **TODO** (planned for future releases)

## Maintenance Workflow

### Normal Development

1. Make changes to a Stellarium directory (fork or local clone)
2. Ensure changes are committed to `master` branch
3. Run `scripts/generate-patches.sh` to extract patches
4. Commit patches to this repository
5. CI automatically validates against upstream

### When Upstream Updates

1. Review new Stellarium release changelog
2. Update `config/stellarium-version.txt`
3. Update your changes for new version (rebase/merge/manual)
4. Regenerate patches (may need manual conflict resolution)
5. Test thoroughly with CI
6. Tag new release: `upstream.X.Y_mosaicplugin.A.B.C`

### When Patches Fail to Apply

1. Clone fresh Stellarium at target version
2. Try to apply patches, note which ones fail
3. Manually apply failed changes
4. Commit fixes to `master` branch
5. Regenerate all patches
6. Push and verify CI passes

## Technical Details

### Modified Files

The patches modify these upstream Stellarium files:

| File | Purpose |
|------|---------|
| `CMakeLists.txt` | Add MosaicCamera plugin to build |
| `plugins/Oculars/src/Oculars.hpp` | Mosaic properties and method declarations |
| `plugins/Oculars/src/Oculars.cpp` | Core mosaic calculation and rendering (~620 lines) |
| `plugins/Oculars/src/gui/OcularsGuiPanel.hpp` | GUI controls for mosaic mode |
| `plugins/Oculars/src/gui/OcularsGuiPanel.cpp` | GUI implementation |
| `plugins/Oculars/src/CMakeLists.txt` | Test configuration |

### Key Implementation

- **Mosaic Calculation**: `Oculars::calculateMosaicPanels()` in `Oculars.cpp`
- **Rendering**: `Oculars::paintMosaicBounds()` in `Oculars.cpp`
- **FOV Calculation**: Reuses `CCD::getActualFOVx/y()` from Oculars
- **Coordinate Transform**: Uses Stellarium's `StelProjector` infrastructure

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

For significant changes, please open an issue first to discuss.

## License

This plugin follows Stellarium's license (GPLv2+). See the [Stellarium license](https://github.com/Stellarium/stellarium/blob/master/COPYING) for details.

## Credits

- **Stellarium Team**: For the amazing planetarium software
- **Mosaic Plugin**: Ryder Cobean
- **Original Oculars Plugin**: Timothy Reaves and contributors

## Support

- **Issues**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)
- **Stellarium**: [Official Website](https://stellarium.org)

## Related Projects

- [Stellarium](https://github.com/Stellarium/stellarium) - Main planetarium software
- [N.I.N.A.](https://nighttime-imaging.eu/) - Astrophotography imaging suite with mosaic planning
- [Telescopius](https://telescopius.com/) - Web-based telescope simulator

## Changelog

See [Releases](../../releases) for version history.

---

**Current Stellarium Version**: `v25.3`
**Plugin Version**: `0.5.0`
**Release Tag**: `upstream.25.3_mosaicplugin.0.5.0`

### Version Scheme

This project uses a versioning scheme that tracks both the upstream Stellarium version and the plugin version:

```
upstream.<stellarium-version>_mosaicplugin.<plugin-version>
```

**Example**: `upstream.25.3_mosaicplugin.0.5.0`
- Stellarium base version: 25.3
- Mosaic plugin version: 0.5.0

See [latest release](../../releases/latest) for downloads and full release notes.
