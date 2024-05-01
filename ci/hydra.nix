{ pkgs, system }:
let
  inherit (pkgs) lib stdenv;
  filter = pkgs.callPackage ./filter.nix { };
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  extraIgnores = if isDarwin then filter.darwinIgnores else [ ];
in

with filter;
{
  build_4_14 = ocamlCandidates {
    inherit pkgs;
    ocamlVersion = "4_14";
  };
  build_5_1 = ocamlCandidates {
    inherit pkgs;
    ocamlVersion = "5_1";
    extraIgnores = extraIgnores ++ ocaml5Ignores;
  };
  build_5_2 = ocamlCandidates {
    inherit pkgs;
    ocamlVersion = "5_2";
    extraIgnores = extraIgnores ++ ocaml5Ignores;
  };

  build_top-level-packages =
    { inherit (pkgs) melange-relay-compiler hermes; } //
    (if stdenv.isLinux then {
      inherit (pkgs) esy kubernetes;
      hermes-musl64 = pkgs.pkgsCross.musl64.hermes;
    } else { });

  arm64_4_14 = (if system == "x86_64-linux" then
    crossTarget pkgs.pkgsCross.aarch64-multiplatform-musl "4_14"
  else
    { });

  musl_4_14 = (if system == "x86_64-linux" then
    crossTarget pkgs.pkgsCross.musl64 "4_14"
  else
    { }
  );

  arm64_5_1 = (if system == "x86_64-linux" then
    crossTarget pkgs.pkgsCross.aarch64-multiplatform-musl "5_1"
  else
    { });

  musl_5_1 = (if system == "x86_64-linux" then
    crossTarget pkgs.pkgsCross.musl64 "5_1"
  else
    { }
  );

  arm64_5_2 = (if system == "x86_64-linux" then
    crossTarget pkgs.pkgsCross.aarch64-multiplatform-musl "5_2"
  else
    { });

  musl_5_2 = (if system == "x86_64-linux" then
    crossTarget pkgs.pkgsCross.musl64 "5_2"
  else
    { }
  );
}
