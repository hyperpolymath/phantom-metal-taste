;; SPDX-License-Identifier: MPL-2.0
;; SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
;;
;; Development environment for Phantom Metal Taste.
;;
;;   guix shell -m manifest.scm
;;   guix time-machine -C channels.scm -- shell -m manifest.scm
;;
;; Rust is available from Guix. Julia and Bun are installed via mise because
;; this pinned Guix channel does not provide the requested versions. mise.lock
;; is still pending official generation, so setup is not yet checksum-locked.
(specifications->manifest
 (list "git" "bash" "coreutils" "nss-certs" "just" "mise" "shellcheck"
       "rust" "rust:cargo" "gcc-toolchain" "pkg-config"))
