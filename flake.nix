{
  description = "fizzbuzz haskell project demo";

  inputs.nixpkgs.url = flake:unstable;
  
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        
        name = "fizzbuzz";
        compiler = "ghc8102";
        useHoogle = true;
        
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowUnsupportedSystem = true;
          };
        };

        hspkgs = pkgs.haskell.packages.${compiler}.extend (self: super: {
          ghc = super.ghc //
                { withPackages = if useHoogle then super.ghc.withHoogle else super.ghc.withPackages;
                  ghcWithPackages = self.ghcWithPackages;
                };
          # other haskell overrides here...
        });

        drv = hspkgs.callCabal2nix name ./. {};

      in
        rec {
          devShell = drv.env;
          #devShell = (import ./shell.nix { inherit pkgs; }).env;
          defaultPackage = drv;
        }
    );
}
