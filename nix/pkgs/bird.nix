{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/bird/releases/download/v0.6.0/bird-macos-universal-v0.6.0.tar.gz";
      hash = "sha256-HdvyNBkq96RUr7vNtDHvqbKv57w/SVLV3AWiaiMUOdo=";
    };
  };
in
stdenv.mkDerivation {
  pname = "bird";
  version = "0.6.0";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp bird "$out/bin/bird"
    chmod 0755 "$out/bin/bird"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast X CLI for tweeting, replying, and reading";
    homepage = "https://github.com/steipete/bird";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "bird";
  };
}
