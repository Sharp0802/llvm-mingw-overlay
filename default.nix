{ lib, pkgs, ... }:
let
  inherit (builtins) head mapAttrs attrNames;

  stdenv = pkgs.llvmPackages.stdenv;
  arch = head (lib.splitString "-" stdenv.hostPlatform.system);

  versions = import ./hash.nix;

  mkHash = { crt, ver }: versions."${ver}"."${crt}"."${arch}";

  mkDerivation =
    inputs@{ crt, ver }:
    stdenv.mkDerivation {
      pname = "llvm-mingw-${crt}";
      version = "${ver}";

      src = pkgs.fetchurl {
        url = "https://github.com/mstorsjo/llvm-mingw/releases/downloads/${ver}/llvm-mingw-${ver}-${crt}-ubuntu-22.04-${arch}.tar.xz";
        hash = mkHash inputs;
      };

      nativeBuildInputs = [
        pkgs.autoPatchelfHook
      ];

      buildInputs = [
        stdenv.cc.cc.lib
        pkgs.zlib
        pkgs.zstd
      ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        mkdir -p $out
        cp -r ./* $out/
        rm -f $out/bin/lldb*
        rm -f $out/lib/liblldb*
      '';
    };

  mkVersion = ver: {
    name = ver;
    value = {
      ucrt = mkDerivation {
        crt = "ucrt";
        inherit ver;
      };

      msvcrt = mkDerivation {
        crt = "msvcrt";
        inherit ver;
      };
    };
  };
in
  mapAttrs (ver: _hash: mkVersion ver) versions
  // { latest = (mkVersion (head (attrNames versions))).value; }
