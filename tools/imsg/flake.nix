{
  description = "clawdbot plugin: imsg";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=16c7794d0a28b5a37904d55bcca36003b9109aaa&narHash=sha256-fFUnEYMla8b7UKjijLnMe%2BoVFOz6HjijGGNS1l7dYaQ%3D";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = builtins.currentSystem;
      packagesForSystem = root.packages.${system} or {};
      imsg = packagesForSystem.imsg or null;
    in {
      packages.${system} = if imsg == null then {} else { imsg = imsg; };

      clawdbotPlugin = if imsg == null then null else {
        name = "imsg";
        skills = [ ./skills/imsg ];
        packages = [ imsg ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
