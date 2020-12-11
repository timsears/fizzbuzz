{
  description = "fizzbuzz haskell project demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nixpkgs.url = flake:unstable;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true;
                     allowBroken = true;
                     allowUnsupportedSystem = true;
                   };
        };

      in
        rec {
          devShell = (import ./shell.nix { inherit pkgs; }).env;
          defaultPackage = (import ./shell.nix { inherit pkgs; });
        }
    );
}
