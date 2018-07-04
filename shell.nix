{ compiler ? "ghc822"
, withHoogle ? true
, pinPackages ? true
}:

(import ./release.nix { inherit compiler withHoogle pinPackages; })

