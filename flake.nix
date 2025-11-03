{
  description = "Development flake for Audacity";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        name = "audacity";
        src = ./.;
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [
              git
              cmake
              gdb
              python313
              python313Packages.pip
              python313Packages.requests

              qt6.qtbase
              qt6.qttools
              qt6.qtdeclarative
              qtcreator

              # this is for the shellhook portion
              # qt6.wrapQtAppsHook
              # makewrapper
              # bashinteractive
            ];

            # shellhook = ''
            #   export qt_qpa_platform=wayland
            #   bashdir=$(mktemp -d)
            #   makewrapper "$(type -p bash)" "$bashdir/bash" "''${qtwrapperargs[@]}"
            #   exec "$bashdir/bash"
            # '';
          };

        packages.default = derivation {
          inherit system name src;
          builder = with pkgs; "${bash}/bin/bash";
          args = ["-c" "echo foo > $out"];
        };
      }
    );
}
