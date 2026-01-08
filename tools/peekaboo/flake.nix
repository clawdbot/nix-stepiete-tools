{
  description = "clawdbot plugin: peekaboo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=16c7794d0a28b5a37904d55bcca36003b9109aaa&narHash=sha256-fFUnEYMla8b7UKjijLnMe%2BoVFOz6HjijGGNS1l7dYaQ%3D";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = builtins.currentSystem;
      packagesForSystem = root.packages.${system} or {};
      peekaboo = packagesForSystem.peekaboo or null;
    in {
      packages.${system} = if peekaboo == null then {} else { peekaboo = peekaboo; };

      clawdbotPlugin = if peekaboo == null then null else {
        name = "peekaboo";
        skills = [ ./skills/peekaboo ];
        packages = [ peekaboo ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
