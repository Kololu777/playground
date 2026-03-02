{
  description = "practice devshell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          pkgs.python3
          pkgs.uv
        ];
      };

      shellHook = ''
        echo "Welcome to the development shell!"
        if [ ! -d ".venv" ]; then
          uv venv .venv
        fi
        source .venv/bin/activate
      '';
    };
}
