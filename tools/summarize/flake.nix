{
  description = "clawdbot plugin: summarize";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=16c7794d0a28b5a37904d55bcca36003b9109aaa&narHash=sha256-fFUnEYMla8b7UKjijLnMe%2BoVFOz6HjijGGNS1l7dYaQ%3D";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = builtins.currentSystem;
      packagesForSystem = root.packages.${system} or {};
      summarize = packagesForSystem.summarize or null;
    in {
      packages.${system} = if summarize == null then {} else { summarize = summarize; };

      clawdbotPlugin = if summarize == null then null else {
        name = "summarize";
        skills = [ ./skills/summarize ];
        packages = [ summarize ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
