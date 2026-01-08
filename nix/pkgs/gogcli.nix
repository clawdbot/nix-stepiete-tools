{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.4.2/gogcli_0.4.2_darwin_arm64.tar.gz";
      hash = "sha256-RC08Z/iBORPv/1Amt7nONFEj9j6OXkXN0RsDNuR8qBM=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.4.2/gogcli_0.4.2_linux_amd64.tar.gz";
      hash = "sha256-dktV5uti+/av5gAg7hblkHtMf6I6gaEjXN+29NnpG28=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.4.2/gogcli_0.4.2_linux_arm64.tar.gz";
      hash = "sha256-8Y4ax0Y/WLrHVPgR1B5ld79ulHtNrpWiASCI89Vdpic=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.4.2";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp gog "$out/bin/gog"
    chmod 0755 "$out/bin/gog"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Google CLI for Gmail, Calendar, Drive, and Contacts";
    homepage = "https://github.com/steipete/gogcli";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "gog";
  };
}
