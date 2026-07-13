{
  description = "An overlay for LLVM-based MinGW toolchains.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      overlay = final: _prev: {
        llvm-mingw = import ./. {
          lib = nixpkgs.lib;
          pkgs = final;
        };
      };
    in
    {
      overlays = {
        default = overlay;
        llvm-mingw-overlay = overlay;
      };
    };
}
