(use-modules (tassos-guix develop)
             (gnu packages llvm)
             (gnu packages guile)
             (gnu packages haskell-xyz)
             (gnu packages haskell-apps)
             (gnu packages crates-io)
             (gnu packages crates-graphics)
             (guix gexp)
             (guix packages)
             (guix download)
             (guix git-download)
             (guix build-system cargo)
             (guix build-system haskell)
             ((guix licenses) #:prefix license:))

(define %source-dir
  (dirname (current-filename)))

(define ghc-graphdoc
  (package
   (name "ghc-graphdoc")
   (version "0.0.1")
   (source
    (local-file %source-dir
                #:recursive? #t
                #:select? (git-predicate %source-dir)))
   (build-system haskell-build-system)
   (inputs
    (list ghc-pandoc
          ghc-pandoc-types))
   (home-page "")
   (synopsis "")
   (description "")
   (license license:gpl3+)))

(de->manifest
 (development-environment
  (package ghc-graphdoc)))
