<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk> -->
# Agent instructions for Phantom Metal Taste

Read `phantom-metal-taste_chora.deed` and the relevant current standards before
making changes. The repository's binding policy is in
`hyperpolymath/standards` and `hyperpolymath/rsr-template-repo`; current source
facts are authoritative over old design prose. Descriptive metadata uses the
current DEED format; `.a2ml` is retired.

## What exists today

- Rust workspace at the root; the crate source is in `src/core/`.
- Julia package at the root (`Project.toml`, `src/PhantomAnalytics.jl`) with
  prototype analyses in `src/analytics/` and tests in `test/`.
- Bun site builder in `scripts/build-site.mjs`, configured by `site.json`.
- Five `.affine` orchestration files are TODO scaffolds. Do not claim the
  AffineScript semantic port is complete.
- No HTTP API, server, loader, or database integration is implemented.
  `compose.yml` is optional local infrastructure only.

## Tooling and commands

The declared project toolchain is mise (`mise.toml`), with Just, ShellCheck,
Rust, Julia, and Bun. `mise.lock` is not yet generated; do not claim the
resolution is reproducible until an official `mise lock` result is checked in.
Guix setup is described in `manifest.scm`, `guix.scm`, and `channels.scm`.

```sh
./launcher.sh --setup
just build
just test
just lint
just fmt-check
just site-check
just doctor
```

The root `Justfile` delegates provisioning verbs to the standard engine in
`build/just/`. Do not hand-edit vendored provisioning engine files for local
project behavior; use the deed or a root recipe. `just run` is intentionally
N/A because there is no application entry point.

## Language and architecture policy

Follow current standards. The active runtimes/toolchains are Rust, Julia, and
Bun; AffineScript is the intended application language for future orchestration
work, but compiler support and domain behavior must be verified first. Do not
introduce Deno, ReScript, TypeScript, Node.js, npm/yarn/pnpm, Python, Go, Java,
Make, or Nix as active project paths.

Keep all public claims honest: design diagrams, the case study, and TLA+
specifications are not evidence that an API, database integration, production
service, or formal verification run exists. Add tests with implementation, and
report unavailable Rust/Julia tests as unverified rather than passed.

## Change hygiene

- Make the smallest coherent change; preserve existing SPDX licence terms.
- Add SPDX headers to new source/config files where the format permits it.
- Never add secrets, hard-coded credentials, or fabricated lock entries.
- Do not modify `.github/workflows/actions.lock` or `mise.lock` by hand; generate
  them with the official tools and review the diff.
- Keep documentation, Just recipes, GitHub CI, and GitLab CI consistent with the
  implemented source and its limitations.
- Update `phantom-metal-taste_chora.deed` and the current remediation plan when
  repository facts, blockers, or verified status materially change.
