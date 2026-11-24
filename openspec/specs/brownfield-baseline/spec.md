# Brownfield baseline

## Purpose
Describe inspected source and build configuration at `33a279e017267c24b099f10e6650b700620d6c10`. Source observations are not runtime acceptance. See `.engineering/baseline.md` for evidence and unknowns.

## Requirements
### Requirement: Evidence classification
The project SHALL distinguish source-observed behavior, executed evidence, intended changes and unknown runtime behavior.

#### Scenario: Unsupported runtime claim
- **WHEN** source or a workflow describes a feature without installed application evidence
- **THEN** the capability is recorded as source-observed and runtime-unverified

### Requirement: Preserve observed integration
The bootstrap SHALL preserve existing source, patch, test and release behavior while recording its limitations.

#### Scenario: Governance-only change
- **WHEN** the governance stage is submitted
- **THEN** no existing product source or test is disabled or replaced

#### Scenario: Incomplete baseline coverage
- **WHEN** test files exist without proven discovery and execution
- **THEN** their presence is recorded without claiming passing tests or coverage

### Requirement: Source-observed Mosaic integration boundary
The baseline SHALL identify the six patches to root CMake and existing Oculars declarations, implementation, GUI and build registration, plus the MosaicCamera and Oculars test overlay, as source-observed integration. See `.engineering/baseline.md` for the audited source and upstream SHAs.

#### Scenario: Executed pinned patch application
- **WHEN** the existing apply script runs against isolated upstream v25.3 commit f9d9c26ac3aaea4e7d5fa9c76d9b8b87489f4bb0
- **THEN** the audited execution checks and applies all six patches and copies the overlay, with existing whitespace warnings; this does not prove compilation or runtime correctness

#### Scenario: Changed Oculars paths
- **WHEN** reviewing existing sensor drawing and HUD paths changed by the implementation patch
- **THEN** unchanged feature-disabled Oculars behavior remains explicitly unknown until same-SHA upstream differential regression executes

#### Scenario: Existing test registration gap
- **WHEN** examining the ENABLE_TESTING branch in patch 006 and its test overlay
- **THEN** ADD_SUBDIRECTORY(test) is source-observed but the overlay lacks that directory's CMakeLists.txt; test build/discovery and independent geometry/persistence coverage remain unverified
