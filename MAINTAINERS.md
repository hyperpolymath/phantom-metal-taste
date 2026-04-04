# Maintainers

This document lists the maintainers of the Phantom Metal Taste project.

## Current Maintainers

### Core Team

- **Primary Maintainer**: [Your Name]
  - GitHub: [@yourusername](https://github.com/yourusername)
  - Role: Architecture, ReScript, Deno, overall direction
  - Focus: Type safety, functional programming, philosophical coherence
  - Timezone: UTC-8 (PST/PDT)

### Component Maintainers

**Database Layer** (ArangoDB, Virtuoso):
- Maintainer TBD
- Responsibilities: Graph queries, SPARQL, ontology design

**Statistical Analysis** (Julia):
- Maintainer TBD
- Responsibilities: Gaming detection, causal inference, impact analysis

**Performance Layer** (Rust/WASM):
- Maintainer TBD
- Responsibilities: Core algorithms, WASM compilation, optimization

**Documentation**:
- Maintainer TBD
- Responsibilities: Guides, architecture docs, case studies

## Emeritus Maintainers

None yet - this is a new project!

## Becoming a Maintainer

### Criteria

We follow the **Tri-Perimeter Contribution Framework (TPCF)**:

**Perimeter 3: Community Sandbox (Current Status)**
- Open to all contributors
- No commit access required
- Fork-and-PR workflow
- Code review required

**Path to Perimeter 2: Verified Contributors**
Requirements:
- 5+ merged PRs of substance
- Demonstrated understanding of project philosophy
- Active for 3+ months
- No Code of Conduct violations
- Endorsement from 2 existing maintainers

Privileges:
- Triage issues
- Review PRs
- Label and close issues
- Direct commit to documentation

**Path to Perimeter 1: Core Team**
Requirements:
- 6+ months as Perimeter 2 contributor
- Deep expertise in one or more components
- Sustained high-quality contributions
- Alignment with project values
- Unanimous approval from Core Team

Privileges:
- Commit access to all repositories
- Release management
- Architecture decisions
- Maintainer voting rights

### Application Process

1. **Self-nominate** or be nominated by a current maintainer
2. **Demonstrate** contributions (link to PRs, issues, discussions)
3. **Write** a brief statement: Why this project? What will you maintain?
4. **Interview** (30-minute video call with 2 current maintainers)
5. **Vote** (unanimous for P1, majority for P2)

Send nominations to: maintainers@phantom-metal-taste.org

## Maintainer Responsibilities

### All Maintainers

- **Review PRs** within 7 days (or delegate)
- **Respond to issues** within 48 hours (even if just to acknowledge)
- **Follow Code of Conduct** - model excellent behavior
- **Document decisions** - especially controversial ones
- **Maintain philosophical alignment** - critique rigorously, kindly

### Core Team Additional Duties

- **Release management** - versioning, changelogs, announcements
- **Security response** - triage and fix vulnerabilities
- **Governance decisions** - TPCF boundaries, architecture changes
- **Mentorship** - help Perimeter 2/3 contributors grow

## Decision-Making Process

### Lazy Consensus (Default)
- Propose change in issue/PR
- Wait 72 hours
- If no objections, proceed
- Good for: docs, minor fixes, refactors

### Majority Vote (Component Decisions)
- Requires 50%+1 of component maintainers
- 7-day voting period
- Good for: API changes, dependency updates, test requirements

### Unanimous Vote (Architecture Changes)
- Requires all Core Team members
- 14-day discussion period
- Good for: TPCF changes, license changes, core philosophy shifts

### Deadlock Resolution
- If no consensus after 30 days
- External mediator from similar projects
- Final decision by Primary Maintainer
- Documented in `docs/decisions/ADR-NNN.md`

## Stepping Down

Maintainers can step down at any time:

1. **Announce** in maintainers channel + public issue
2. **Transfer** active PRs/issues to other maintainers
3. **Document** in-progress work
4. **Move to Emeritus** (with our gratitude!)

No shame in stepping down - life happens, priorities change.

## Removal

A maintainer may be removed for:
- **Code of Conduct violations** (serious or repeated)
- **Inactive** >6 months without notice
- **Harmful behavior** to project or community
- **Unanimous vote** by other Core Team members

Process:
1. Private discussion with maintainer
2. Attempt mediation
3. If unresolved, vote
4. Public explanation (respecting privacy as much as possible)

## Emeritus Benefits

Former maintainers who left in good standing:
- Listed in this file forever
- Access to private maintainer discussions (if desired)
- Input on major decisions
- Credit in releases
- Our deep thanks

## Contact

- **Public**: Open an issue
- **Private**: maintainers@phantom-metal-taste.org
- **Security**: security@phantom-metal-taste.org (see SECURITY.md)
- **Code of Conduct**: conduct@phantom-metal-taste.org

## Acknowledgments

This project exists because maintainers volunteer their time.

**Thank you** for considering joining this work.

---

*"Maintainership is not authority, it's service."*

Last updated: 2024-11-22
