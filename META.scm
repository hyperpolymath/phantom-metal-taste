;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
;;; META.scm — phantom-metal-taste

(define-module (phantom-metal-taste meta)
  #:export (architecture-decisions development-practices design-rationale))

(define architecture-decisions
  '((adr-001
     (title . "RSR Compliance")
     (status . "accepted")
     (date . "2025-12-15")
     (context . "![License](https://img.shields.io/badge/license-MIT%2BPalimpsest-blue.svg)")
     (decision . "Follow Rhodium Standard Repository guidelines")
     (consequences . ("RSR Gold target" "SHA-pinned actions" "SPDX headers" "Multi-platform CI")))))

(define development-practices
  '((code-style (languages . ("Julia" "Just" "Nix" "ReScript" "Rust" "Scheme" "Shell" "TLA" "TypeScript")) (formatter . "JuliaFormatter") (linter . "StaticLint.jl"))
    (security (sast . "CodeQL") (credentials . "env vars only"))
    (testing (coverage-minimum . 70))
    (versioning (scheme . "SemVer 2.0.0"))))

(define design-rationale
  '((why-rsr "RSR ensures consistency, security, and maintainability.")))
;; ============================================================================
;; CROSS-PLATFORM STATUS (Added 2025-12-17)
;; ============================================================================
;; ATTENTION: Both GitHub and GitLab were active on the same day.
;; Manual review required before syncing.

(cross-platform-status
  (generated "2025-12-17")
  (primary-platform "github")
  (gitlab-mirror
    (path "hyperpolymath/phantom-metal-taste")
    (url "https://gitlab.com/hyperpolymath/phantom-metal-taste")
    (last-gitlab-activity "2025-12-17")
    (sync-status "needs-review")
    (notes "Both platforms active same day. Compare before sync."))
  
  (reconciliation-instructions
    ";; STEP 1: Add GitLab remote and fetch"
    ";; git remote add gitlab https://gitlab.com/hyperpolymath/phantom-metal-taste.git"
    ";; git fetch gitlab"
    ";;"
    ";; STEP 2: Compare the two versions"
    ";; git log --oneline main          # GitHub history"
    ";; git log --oneline gitlab/main   # GitLab history"  
    ";; git diff main gitlab/main       # See differences"
    ";;"
    ";; STEP 3: Decide and merge if needed"
    ";; git merge gitlab/main --allow-unrelated-histories"
    ";; OR cherry-pick specific: git cherry-pick <sha>"
    ";;"
    ";; STEP 4: After reconciliation, update this section:"
    ";;   (sync-status \"resolved\")"
    ";;   (resolved-date \"YYYY-MM-DD\")")
  
  (action-required "needs-review"))

