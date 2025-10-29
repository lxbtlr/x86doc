{
  description = "A Nix-flake-based python development environment for cs349";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default =
        pkgs.mkShell.override
        {
          # Override stdenv in order to change compiler:
          #stdenv = pkgs.clangStdenv;
        }
        {
          packages = with pkgs;
            [
              (pkgs.python313.withPackages (ps: with ps; [
                #jsonschema
                #pandas
                pdfminer-six
                numpy
                #matplotlib
                #pytest
                #scipy
                #scikit-learn
              ]))
              #clblas
              virtualenv
              md2pdf
              gcc
            ]
            ++ (
              if system == "aarch64-darwin"
              then []
              else [gdb]
            );
      buildInputs = [];
      shellHook = ''
      export PYTHON_COLORS=1
      #//source env/bin/activate
      '';
        };

    });
  };
}
