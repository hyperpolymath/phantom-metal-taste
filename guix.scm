;; phantom-metal-taste - Guix Package Definition
;; Run: guix shell -D -f guix.scm

(use-modules (guix packages)
             (guix gexp)
             (guix git-download)
             (guix build-system node)
             ((guix licenses) #:prefix license:)
             (gnu packages base))

(define-public phantom_metal_taste
  (package
    (name "phantom-metal-taste")
    (version "0.1.0")
    (source (local-file "." "phantom-metal-taste-checkout"
                        #:recursive? #t
                        #:select? (git-predicate ".")))
    (build-system node-build-system)
    (synopsis "ReScript application")
    (description "ReScript application - part of the RSR ecosystem.")
    (home-page "https://github.com/hyperpolymath/phantom-metal-taste")
    (license license:agpl3+)))

;; Return package for guix shell
phantom_metal_taste
