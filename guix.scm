;; SPDX-License-Identifier: MPL-2.0
;; SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
;;
;; A source package for the complete hybrid repository.
;;
;;   guix build -f guix.scm       # installs the source tree under share/
;;   guix shell -m manifest.scm   # development tools; `just setup` provisions mise tools
;;
;; This repository is a mixed Rust / Julia / Bun project whose application
;; orchestrator is still an AffineScript skeleton. The project-level Guix
;; package therefore preserves the checkout as source rather than claiming one
;; compiled artifact represents the whole project. The Rust workspace, Julia
;; package, and site builder have their own real build/test commands in Justfile.
(use-modules (guix packages)
             (guix gexp)
             (guix build-system copy)
             (gnu packages)
             (srfi srfi-13)
             ((guix licenses) #:prefix license:))

(define %source-dir
  (let ((d (dirname (current-filename))))
    (if (string=? (basename d) "build") (dirname d) d)))

(define (spec->input spec)
  (call-with-values (lambda () (specification->package+output spec))
    (lambda (pkg out) (if (string=? out "out") pkg (list pkg out)))))

(define %ignored
  '(".git" "target" "_site" ".eval" "node_modules" ".cache"
    ".cargo" ".julia" ".env" "secrets" ".ssh" ".aws" ".kube" "credentials"
    ".npmrc" ".netrc" ".pypirc" ".docker" "Manifest.toml"))

(define (sensitive-source-name? file)
  (let ((base (basename file)))
    (or (member base %ignored)
        (string-prefix? ".env." base)
        (string-prefix? "credentials." base)
        (string-prefix? "token." base)
        (string-prefix? "secret." base)
        (string-prefix? "id_rsa" base)
        (string-prefix? "id_ed25519" base)
        (string-suffix? ".pem" base)
        (string-suffix? ".key" base)
        (string-suffix? ".p12" base)
        (string-suffix? ".pfx" base)
        (string-suffix? ".secret" base)
        (string-suffix? ".token" base)
        (string-suffix? ".log" base))))

(package
  (name "phantom-metal-taste")
  (version "0.1.0")
  (source (local-file %source-dir "phantom-metal-taste-checkout"
                      #:recursive? #t
                      #:select? (lambda (file stat)
                                  (not (sensitive-source-name? file)))))
  (build-system copy-build-system)
  (arguments (list #:install-plan #~'(("." "share/phantom-metal-taste/"))))
  (native-inputs (map spec->input
                      (list "git" "bash" "coreutils" "nss-certs" "just" "mise"
                            "shellcheck" "rust" "rust:cargo" "gcc-toolchain" "pkg-config")))
  (home-page "https://github.com/hyperpolymath/phantom-metal-taste")
  (synopsis "Experimental analytics library and research artefacts")
  (description "A source bundle for an experimental multi-language analytics
project. Its Rust core, Julia analysis package, and Bun-powered site builder are
built and tested through Justfile recipes; the AffineScript orchestrator is not
yet implemented.")
  (license license:mpl2.0))
