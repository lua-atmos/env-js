# Plan: build

## Context

`build.sh` has a single `VERSION="v0.5"` constant used as a
comment in generated HTML. The module lists hardcode `main` as
the branch/tag for every repo. There is no per-repo version
tracking — making it hard to know which tag of each dependency
was used in a given build.

**Goal:** Rename `build.sh` to `build-v0.5.sh` with a
`VERSIONS` associative array (overall + per-repo). Each future
release gets its own `build-vX.Y.sh`. CI runs all build
scripts, keeping past releases tested.

## Status

- [ ] 1. Rename `build.sh` → `build-v0.5.sh` + VERSIONS array
- [ ] 2. Update module lists to use `${VERSIONS[...]}`
- [ ] 3. Update `generate_html` for versioned filenames
- [ ] 4. Update `.github/workflows/test.yml`
- [ ] 5. Extract `test/common.mjs` from `test/test.mjs`
- [ ] 6. Rename `test/test.mjs` → `test/test-v0.5.mjs`
- [ ] 7. Update `test/package.json`
