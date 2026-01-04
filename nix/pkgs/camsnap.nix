{ lib, stdenv, fetchurl, ffmpeg }:

stdenv.mkDerivation {
  pname = "camsnap";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/steipete/camsnap/releases/download/v0.2.0/camsnap-macos-arm64.tar.gz";
    hash = "sha256-YSgnkN9HuSPbYC0ioR95blkUfcHEye6aQSW7lqKzgz4=";
  };

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/camsnap"
    cp $(find . -type f -name camsnap | head -1) "$out/bin/camsnap"
    chmod 0755 "$out/bin/camsnap"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/camsnap/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/camsnap/"
    fi
    runHook postInstall
  '';

  propagatedBuildInputs = [ ffmpeg ];

  meta = with lib; {
    description = "One command to grab frames, clips, or motion alerts from RTSP/ONVIF cams";
    homepage = "https://github.com/steipete/camsnap";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "camsnap";
  };
}
