{
  description = "clawdbot plugin: bird";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=16c7794d0a28b5a37904d55bcca36003b9109aaa&narHash=sha256-fFUnEYMla8b7UKjijLnMe%2BoVFOz6HjijGGNS1l7dYaQ%3D";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = builtins.currentSystem;
      packagesForSystem = root.packages.${system} or {};
      bird = packagesForSystem.bird or null;
    in {
      packages.${system} = if bird == null then {} else { bird = bird; };

      clawdbotPlugin = if bird == null then null else {
        name = "bird";
        skills = [ ./skills/bird ];
        packages = [ bird ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
