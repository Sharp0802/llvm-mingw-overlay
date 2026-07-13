# llvm-mingw-overlay

An overlay for LLVM-based mingw-w64 toolchain for flakes.

This simply exposes prebuilt things of [`llvm-mingw`](https://github.com/mstorsjo/llvm-mingw) repository from its releases.

Supported systems:

- `x86_64-linux` (UCRT, MSVCRT)
- `aarch64-linux` (UCRT)

## Installation

> [!WARNING]
> Only the output `overlays` are stable.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    llvm-mingw-overlay.url = "github:Sharp0802/llvm-mingw-overlay";
  };

  outputs = { nixpkgs, llvm-mingw-overlay, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix # Your system conf.
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              llvm-mingw-overlay.overlays.default
            ];

            environment.systemPackages = [
              pkgs.llvm-mingw.latest.ucrt # or msvcrt if you want
            ];
          })
        ];
      };
    };
  };
}
```

## Usage

> [!WARNING]
> Currently only `latest` and version `20260616` are supported.

Overlay provides such packages:

```
llvm-mingw.latest.ucrt
llvm-mingw.latest.msvcrt
llvm-mingw.${version}.ucrt
llvm-mingw.${version}.msvcrt
```

`version` is a tag name of the release (e.g. `20260616`).

See [Tags](https://github.com/mstorsjo/llvm-mingw/tags) for the full list of tags.

See [hash.nix](./hash.nix) for the available list of tags.

## License

MIT licensed.
