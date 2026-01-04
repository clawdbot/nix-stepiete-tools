{
  description = "clawdbot plugin: camsnap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      camsnap = root.packages.${system}.camsnap;
    in {
      packages.${system}.camsnap = camsnap;

      clawdbotPlugin = {
        name = "camsnap";
        skills = [ ./skills/camsnap ];
        packages = [ camsnap ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
