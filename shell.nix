{ pkgs
, compiler ? "ghc8102"
, withHoogle ? true
}:

let
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
  drv = hspkgs.callPackage (import ./default.nix) {};
in
# with pkgs; buildEnv {
#   name = "dev env";
#   paths = [
#     hspkgs
#     drv
#     cabal2nix
#     cabal-install
#   ];
# }
drv

#if pkgs.lib.inNixShell then drv.env else { ${drv.pname} = drv; }

