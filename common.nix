{name, version, homepage}:

let
  windows32 = import <nixpkgs> {
#    system = "i686-linux"; # local system
    crossSystem = {
      config = "i686-w64-mingw32";
      arch = "x86";
      libc = "msvcrt";
      platform = {};
      openssl.system = "mingw";
    };
  };  

  game = {lib, stdenv, nasm, petool}: stdenv.mkDerivation rec {
    inherit name;
    inherit version;

    nativeBuildInputs = [ nasm petool ];
    src = ./..;
    preBuild = "makeFlagsArray=(" + lib.concatStringsSep " " [
      "REV=${version}"
      "CP=cp"
      "CC=${stdenv.cross.config}-gcc"
      "AS=${stdenv.cross.config}-as"
      "WINDRES=${stdenv.cross.config}-windres"
    ] + ")";

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      inherit homepage;
      description = "";
      # maintainers =
      license = map (builtins.getAttr "shortName") [ licenses.mit ];
      # Buildable on any platform, runable only on Windows
      platforms = stdenv.lib.platforms.all;
    };
  };
in windows32.callPackage game {}
