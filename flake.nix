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
          # overlays = [] # Add or tweak non-Haskell packages here.
        };

        haskellPackages = pkgs.haskell.packages.${compiler}.override {
          overrides = self: super: {
            "${name}" = self.callCabal2nix name ./. {};
            # Override other Haskell packages as needed here.
          };
        };
        
        devEnv = haskellPackages.shellFor {
          withHoogle = true; # Provides docs, optional. 
          packages = p: [
            p."${name}"
            # Add other Haskell packages below if you just want a Haskell hacking env.
            # p.lens
          ]; 
          buildInputs = with pkgs; [
            haskellPackages.cabal-install
            haskellPackages.ghcid
            haskellPackages.haskell-language-server
            haskellPackages.hlint
            haskellPackages.ormolu
            cabal2nix
            # Add more dev tools as needed. They won't be included by `nix build`
          ];
        };

        drv = haskellPackages."${name}";
        
      in
        rec {
          devShell = devEnv; # Has more tools than drv.env.
          defaultPackage = drv;
          #packages = drv; # broken???
        });
}
