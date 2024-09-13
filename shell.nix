{ buildInputs, pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = buildInputs;

  shellHook = ''
  '';
}
