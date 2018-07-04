{ compiler ? "ghc822"
, withHoogle ? true
, pinPackages ? true
}:

let
  pinpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
  src = builtins.fetchTarball {
    inherit (pinpkgs) sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${pinpkgs.rev}.tar.gz";
  };
  pkgs = if  pinPackages then import src {} else import <nixpkgs> {};
  f = import ./default.nix;
  packageSet = pkgs.haskell.packages.${compiler};
  hspkgs = (
    if withHoogle then
      packageSet.extend (self: super: {
          ghc = super.ghc // { withPackages = super.ghc.withHoogle; };
          ghcWithPackages = self.ghc.withPackages;
        }
      )
      else packageSet
  );
  drv = hspkgs.callPackage f {};
in
 if pkgs.lib.inNixShell then drv.env else { ${drv.pname} = drv; }

