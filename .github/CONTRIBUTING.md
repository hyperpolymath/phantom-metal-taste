<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk> -->
# Contributing

Thanks for helping improve Phantom Metal Taste. The project is experimental;
please distinguish implemented behavior from design proposals and TODO
scaffolds in reports and pull requests.

## Before changing code

1. Read [`CLAUDE.md`](../CLAUDE.md), [`docs/SETUP.adoc`](../docs/SETUP.adoc),
   and the relevant machine-readable project state.
2. Follow current `hyperpolymath/standards` and
   `hyperpolymath/rsr-template-repo` policy.
3. Do not introduce a new runtime, service, database integration, or claim of
   AffineScript completion without tests and an explicit scope decision.

## Local workflow

```sh
./launcher.sh --setup
just doctor
just build
just test
just lint
just fmt-check
just site-check
```

`just validate` runs the principal local gates. If Rust or Julia is unavailable,
state that the corresponding tests were not run; do not mark them as passing.

## Pull requests

- Keep changes focused and link relevant issues.
- Include tests for behavioral changes and update user-facing docs.
- Use Conventional Commit messages.
- Do not commit secrets, credentials, generated build output, or hand-written
  `mise.lock` / `.github/workflows/actions.lock` data.
- Respect the repository's currently configured required checks and merge settings; do not bypass branch protection or required review.
