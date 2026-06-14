{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [
              (final: prev: {
                bootdev-cli = prev.bootdev-cli.overrideAttrs (old: rec {
                  version = "1.29.6";

                  src = prev.fetchFromGitHub {
                    owner = "bootdotdev";
                    repo = "bootdev";
                    tag = "v${version}";
                    hash = "sha256-nfgmlKIXtQqiharS1ezES5dFa6IE7Q2TvIhh/qiIB2Q";
                  };

                  vendorHash = "sha256-ZDioEU5uPCkd+kC83cLlpgzyOsnpj2S7N+lQgsQb8uY=";

                  postPatch = ''
                    echo v${version} > version.txt
                  '';
                });
              })
            ];
          };
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.python3
              pkgs.uv
              pkgs.ruff
              pkgs.ty
              pkgs.bootdev-cli
            ];

            env = lib.optionalAttrs pkgs.stdenv.isLinux {
              # Python libraries often load native shared objects using dlopen(3).
              # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
              LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            };

            shellHook = ''
              unset PYTHONPATH
              uv sync
              . .venv/bin/activate
            '';
          };
        }
      );
    };
}
