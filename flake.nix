{
  description = "Hello CPP Dev Shell Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixpkgs-unstable,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        buildType = "Debug";
        projectName = "cpp-hello";
        version = "0.1.0";
        unstablePkgs = import nixpkgs-unstable { inherit system; };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (final: prev: { unstable = unstablePkgs; }) ];
        };
        lib = pkgs.lib;
        nativeBuildInputs = with pkgs; [
          nix-direnv
          gcc14
          unstable.clang-tools
          gdb
          cmake
          ninja
          pkg-config
        ];
        buildInputs = with pkgs; [
          boost
          fmt
          gtest
          gbenchmark
          cli11
        ];
        stdenv = pkgs.gcc14Stdenv;
      in
      {
        devShells.default = import ./shell.nix {
          inherit
            buildInputs
            nativeBuildInputs
            pkgs
            stdenv
            ;
        };
        packages =
          let
            fs = lib.fileset;
            sourceFiles = fs.unions [
              ./CMakeLists.txt
              (fs.fileFilter (file: file.hasExt "cpp" || file.hasExt "hpp") ./src)
            ];
          in
          rec {
            app = stdenv.mkDerivation {
              name = projectName;
              version = version;
              outputs = [ "out" ];
              src = fs.toSource {
                root = ./.;
                fileset = sourceFiles;
              };
              buildInputs = buildInputs;
              nativeBuildInputs = nativeBuildInputs;
              donotUnpack = true;
              configurePhase = ''
                cmake -S . -B cmake-build -DCMAKE_BUILD_TYPE=${buildType}
              '';
              buildPhase = ''
                cmake --build cmake-build
              '';
              installPhase = ''
                cmake --install cmake-build --prefix $out
              '';
              meta = {
                description = "Core C++ library";
                license = lib.licenses.mit;
              };
            };
            default = app;
          };
        apps = rec {
          app = {
            type = "app";
            program = "${self.packages.${system}.app}/bin/${projectName}";
          };
          default = app;
        };
      }

    );
}
