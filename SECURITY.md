# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

**DO NOT** open public issues for security vulnerabilities.

### Reporting Process

1. **Email**: Send vulnerability details to security@phantom-metal-taste.org (or repository owner)
2. **PGP**: Use our PGP key (see `.well-known/security.txt`) if available
3. **Response Time**: We aim to respond within 48 hours
4. **Disclosure**: Coordinated disclosure after fix (typically 90 days)

### What to Include

- **Description**: Clear explanation of the vulnerability
- **Impact**: What an attacker could achieve
- **Reproduction**: Step-by-step instructions
- **Affected Versions**: Which versions are vulnerable
- **Suggested Fix**: If you have one (optional)

### Security Considerations

This project implements multi-layered security:

#### 1. Type Safety (ReScript)
- Sound type system eliminates runtime type errors
- Algebraic data types prevent impossible states
- No `null` or `undefined` bugs

#### 2. Memory Safety (Rust/WASM)
- Zero unsafe blocks in production code
- Ownership model prevents use-after-free
- Bounds checking on all array access

#### 3. Runtime Security (Deno)
- Explicit permissions model (`--allow-net`, `--allow-read`, `--allow-env`)
- Sandboxed execution
- No implicit file system or network access

#### 4. Database Security
- Parameterized queries prevent SQL/AQL injection
- Authentication required for all database operations
- Encrypted connections (TLS)

#### 5. Input Validation
- All external inputs validated at API boundaries
- Schema validation with domain types
- Rate limiting on public endpoints

#### 6. Dependency Security
- Minimal dependencies (zero for Rust/WASM core)
- URL-based imports in Deno (explicit versions)
- Regular security audits

#### 7. Data Privacy
- Employee data can be anonymized
- GDPR-compliant data deletion
- Access control by role
- Audit logging

#### 8. Supply Chain Security
- Reproducible builds (see `flake.nix`)
- Signed commits (GPG)
- Verified dependencies

#### 9. Air-Gap Capable
- Can run fully offline after initial setup
- No telemetry or phone-home
- Local-first architecture

#### 10. Defense in Depth
- Multiple security layers
- Fail-safe defaults
- Principle of least privilege

## Security Features by Design

### Offline-First Architecture
The system is designed to work without network access:
- All critical functionality available offline
- No required external API calls
- Local database instances

### Immutable Infrastructure
- Podman containers with pinned versions
- Declarative configuration
- Version-controlled infrastructure

### Audit Trail
All sensitive operations are logged:
- Database queries
- Authentication attempts
- Permission changes
- Data modifications

## Known Security Limitations

1. **Development Environment**: Default passwords in `.env.example` are for development only
2. **Database Exposure**: ArangoDB and Virtuoso web UIs exposed on localhost in dev mode
3. **No Built-in Authentication**: API endpoints currently have no auth (add reverse proxy with auth)
4. **Demo Data**: SynapCor case study contains synthetic but realistic organizational data

## Security Roadmap

Future enhancements:
- [ ] OAuth2/OIDC integration
- [ ] Role-based access control (RBAC)
- [ ] Encryption at rest for sensitive data
- [ ] Security scanning in CI/CD
- [ ] Penetration testing reports
- [ ] CVE monitoring and auto-patching

## Compliance

### Standards Adherence
- **OWASP Top 10**: Mitigations for all categories
- **RFC 9116**: security.txt in `.well-known/`
- **CIS Benchmarks**: Container hardening
- **NIST Cybersecurity Framework**: Identify, Protect, Detect, Respond, Recover

### License Compliance
This project uses:
- Palimpsest License (PMPL-1.0-or-later)

See LICENSE file for details.

## Contact

- **General Security**: security@phantom-metal-taste.org
- **PGP Key**: See `.well-known/security.txt`
- **Security Advisories**: GitHub Security Advisories (when published)

---

*"Security is not a product, but a process. This document is part of that process."*
