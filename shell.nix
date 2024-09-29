{
  buildInputs,
  nativeBuildInputs,
  pkgs,
  stdenv,
}:
pkgs.mkShell.override { stdenv = stdenv; } {
  buildInputs = buildInputs;
  nativeBuildInputs = nativeBuildInputs;

  shellHook = '''';
}
