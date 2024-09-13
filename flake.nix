{
  description = "Hello CPP Dev Shell Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          buildType = "Debug";
          pkgs = import nixpkgs {
            inherit system;
          };
          buildInputs = with pkgs; [
            nix-direnv
            gcc14
            gdb
            cmake
            pkg-config
            boost
            fmt
            gtest
            gbenchmark
            cli11
          ];
        in
        with pkgs;
        {
          devShells.default = import ./shell.nix { inherit buildInputs pkgs; };
          packages =
            let
              fs = lib.fileset;
              sourceFiles = fs.unions [
                ./CMakeLists.txt
                (fs.fileFilter
                  (file: file.hasExt "cpp" || file.hasExt "hpp")
                  ./src
                )
              ];
            in
            rec {
              cpp-hello = stdenv.mkDerivation
                {
                  name = "cpp-hello";
                  version = "0.1.1";
                  outputs = [ "out" ];
                  src = fs.toSource {
                    root = ./.;
                    fileset = sourceFiles;
                  };
                  nativeBuildInputs = buildInputs;
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
              default = cpp-hello;
            };
          apps =
            rec {
              cpp-hello = {
                type = "app";
                program = "${self.packages.${system}.cpp-hello}/bin/cpp-hello";
              };
              default = cpp-hello;
            };
        }

      );
}
