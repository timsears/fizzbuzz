{
  description = "fizzbuzz haskell project demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.pkgs.url = flake:unstable;

  outputs = { self, pkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs' = import pkgs {
          inherit system;
          config = { allowUnfree = true;
                     allowBroken = true;
                     allowUnsupportedSystem = true;
                   };
        };
      in
        {
          devShell = import ./shell.nix { pkgs = pkgs'; };
        }
    );
}
