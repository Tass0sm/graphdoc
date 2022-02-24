(use-modules (gnu packages llvm)
             (gnu packages haskell-xyz)
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
;;    (native-inputs
;;     (list cabal-install))
   (inputs
    (list ghc-pandoc
          ghc-pandoc-types))
   (home-page "")
   (synopsis "")
   (description "")
   (license license:gpl3+)))

(package
 (inherit ghc-graphdoc)
 (name "graphdoc"))
