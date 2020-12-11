{
  description = "fizzbuzz haskell project template"; # Customize

  inputs.nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable"; #Customize
  
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let

        name = "fizzbuzz";     # Customize
        compiler = "ghc8102";  # Customize
         
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowUnsupportedSystem = true;
          };
          # overlays = [] # in case you need to tweak some nix pkgs
        };

        haskellPackages = pkgs.haskell.packages.${compiler}.override {
          overrides = self: super: {
            "${name}" = self.callCabal2nix name ./. {};
            # override other Haskell packages as needed
          };
        };
        
        devenv = haskellPackages.shellFor {
          withHoogle = true;
          packages = p: [ p."${name}" ]; # add others like p.lens for Haskell hacking env.
          buildInputs = with pkgs; [
            haskellPackages.cabal-install
            haskellPackages.ghcid
            haskellPackages.haskell-language-server
            haskellPackages.hlint
            haskellPackages.ormolu
            cabal2nix
            # ... add more tools as needed
          ];
        };

        drv = haskellPackages."${name}";
        
      in
        rec {
          devShell = devenv; # has more tools than drv.env
          defaultPackage = drv;
          #packages = drv; # broken???
        });
}

