{
  description = "clawdbot plugin: oracle";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=16c7794d0a28b5a37904d55bcca36003b9109aaa&narHash=sha256-fFUnEYMla8b7UKjijLnMe%2BoVFOz6HjijGGNS1l7dYaQ%3D";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = builtins.currentSystem;
      packagesForSystem = root.packages.${system} or {};
      oracle = packagesForSystem.oracle or null;
    in {
      packages.${system} = if oracle == null then {} else { oracle = oracle; };

      clawdbotPlugin = if oracle == null then null else {
        name = "oracle";
        skills = [ ./skills/oracle ];
        packages = [ oracle ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
