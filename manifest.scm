(use-modules (tassos-guix develop)
             (graphdoc-package))

(de->manifest
 (development-environment
  (package ghc-graphdoc)))
