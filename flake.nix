{
  description = "Fetch full-loaded HTML from a web page";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pythonEnv = pkgs.python3.withPackages (p: [ p.selenium ]);
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages = rec {
          fetchtml = pkgs.python3Packages.buildPythonPackage {
            pname = "fetchtml";
            version = "0.1.0";
            src = ./main.py;
            propagatedBuildInputs = [
              pkgs.chromium
              pkgs.chromedriver
              pythonEnv
            ];
            format = "other";
            dontUnpack = true;
            buildPhase = ":";
            installPhase = ''
              install -Dm755 $src $out/bin/fetchtml
            '';
          };
          default = fetchtml;
        };
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nixpkgs-fmt
            pkgs.nixd
            pkgs.chromium
            pkgs.chromedriver
            pythonEnv
          ];
        };
      });
}
