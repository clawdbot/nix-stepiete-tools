{
  description = "clawdbot plugin: camsnap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=16c7794d0a28b5a37904d55bcca36003b9109aaa&narHash=sha256-fFUnEYMla8b7UKjijLnMe%2BoVFOz6HjijGGNS1l7dYaQ%3D";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = builtins.currentSystem;
      packagesForSystem = root.packages.${system} or {};
      camsnap = packagesForSystem.camsnap or null;
    in {
      packages.${system} = if camsnap == null then {} else { camsnap = camsnap; };

      clawdbotPlugin = if camsnap == null then null else {
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
