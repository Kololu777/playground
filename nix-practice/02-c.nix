{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    name = "hello-c";
    src = pkgs.writeTextDir "main.c" ''
      #include <stdio.h>

      int main() {
          printf("Hello, C!\n");
          return 0;
      }
    '';

    buildPhase = ''
        $CC -o hello-c main.c
    '';

    installPhase = ''
        mkdir -p $out/bin
        cp hello-c $out/bin/
    '';
}