(define-module (graphdoc-package)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages haskell-apps)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-graphics)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system haskell)
  #:use-module ((guix licenses) #:prefix license:))

(define vcs-file?
  ;; Return true if the given file is under version control.
  (or (git-predicate (string-append (current-source-directory) "/../.."))
      (const #t)))

(define-public ghc-graphdoc
  (package
    (name "ghc-graphdoc")
    (version "0.0.1")
    (source (local-file "../.." "graphdoc-checkout"
                        #:recursive? #t
                        #:select? vcs-file?))
    (build-system haskell-build-system)
    (inputs
     (list ghc-fgl
           ghc-pandoc
           ghc-pandoc-types))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:gpl3+)))

ghc-graphdoc
