# Beads roadmap references

This is an ID map, not a second task board. Status and dependencies live in repository-local Beads. OpenSpec `modernize-stellarium` defines proposed behavior; all future work remains unimplemented.

- epic: `mosaic-rbk`
- bootstrap: `mosaic-rbk.1`
- upstream: `mosaic-rbk.2`
- build: `mosaic-rbk.3`
- regression: `mosaic-rbk.4`
- coverage: `mosaic-rbk.5`
- gui: `mosaic-rbk.6`
- lab: `mosaic-rbk.7`
- agent: `mosaic-rbk.8`
- upstream_pr: `mosaic-rbk.9`

Cross-repository external dependency references point to the peer GUI/bootstrap capabilities. Resolve them against the peer local board before lab or maintenance work. No provisioning is authorized here.

Cross-project capability targets carry `export:<ID>` labels. Only after closure run `bd ship <ID>`; `provides:` labels are reserved. Register peer checkout roots under `external_projects` in private `.beads/config.local.yaml` (never commit machine paths). Unavailable/unshipped peers remain blocking.
