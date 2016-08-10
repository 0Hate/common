let
  crossSystem = {
    config = "i686-w64-mingw32";
    arch = "x86";
    libc = "msvcrt";
    platform = {};
    openssl.system = "mingw";
  };
in import <nixpkgs> {
  inherit crossSystem;
  config = {
    packageOverrides = super: let self = super.pkgs; in {
      petool = self.callPackage (self.fetchFromGitHub {
        owner = "cnc-patch";
        repo = "petool";
        rev = "f0231058829dcb34f04d0e427b464371a44f8522";
        sha256 = "0qjf4bzj52j6sw4rl7nndkz335k1vjgfd13lrqwihsjhicbyj71m";
      }) {};
      mkCncGame = self.callPackage ./template.nix {};
    };
  };
}
