{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.5.4/gogcli_0.5.4_darwin_arm64.tar.gz";
      hash = "sha256-/j/T2C11DeK0ft6RCc65cc4raTorw0DgWoIxuebL5CU=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.5.4/gogcli_0.5.4_linux_amd64.tar.gz";
      hash = "sha256-TPXXROi05I+FwQ3TNfyHlKc1LvNn6XW41tOem2kaynM=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.5.4/gogcli_0.5.4_linux_arm64.tar.gz";
      hash = "sha256-DDkgfvs7R25LxQaBg2rMgiTtB+L3UAYzZ726heOM/zc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.5.4";

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
