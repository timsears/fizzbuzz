{ mkDerivation, base, profunctors, stdenv }:
mkDerivation {
  pname = "fizzbuzz";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base profunctors ];
  license = stdenv.lib.licenses.unfree;
  hydraPlatforms = stdenv.lib.platforms.none;
}
