{ name, version, homepage }:

let
  pkgs = import <nixpkgs> {};

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

  petool = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "cnc-patch";
    repo = "petool";
    rev = "a7754d0362ff3a8600c859a2dc4c3a9d92bbe586";
    sha256 = "0qlp79gpn6xfngdmqrpcb8xdv25ady3ww545v7jhcff98g16znjh";
  }) {};

  game = { lib, stdenv, nasm }: stdenv.mkDerivation rec {
    inherit name;
    inherit version;

    nativeBuildInputs = [ nasm petool ];
    src = ./..;
    preBuild = "makeFlagsArray=(" + lib.concatStringsSep " " [
      # Miscellaneous
      "REV=${version}"
      "CP=cp"
      # GNU Compiler Collection
      "CC=${stdenv.cross.config}-gcc"
      "CXX=${stdenv.cross.config}-g++"
      # GNU Binutils
      "AS=${stdenv.cross.config}-as"
      "WINDRES=${stdenv.cross.config}-windres"
      "LD=${stdenv.cross.config}-ld"
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
