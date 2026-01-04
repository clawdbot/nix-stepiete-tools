#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v jq >/dev/null 2>&1; then
  echo "[update-tools] jq is required" >&2
  exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "[update-tools] nix is required" >&2
  exit 1
fi

prefetch_hash() {
  local url="$1"
  nix store prefetch-file --json "$url" | jq -r .hash
}

latest_release() {
  local repo="$1"
  gh api "repos/${repo}/releases/latest"
}

update_nix_file() {
  local file="$1"
  local version="$2"
  local url="$3"
  local hash="$4"

  python3 - <<PY
from pathlib import Path
import re

path = Path("$file")
text = path.read_text()
text, n1 = re.subn(r'version = "[^"]+";', f'version = "{version}";', text, count=1)
text, n2 = re.subn(r'url = "[^"]+";', f'url = "{url}";', text, count=1)
text, n3 = re.subn(r'hash = "sha256-[^"]+";', f'hash = "{hash}";', text, count=1)

if n1 == 0 or n2 == 0 or n3 == 0:
    raise SystemExit(f"update failed for {path}: version/url/hash not found")

path.write_text(text)
PY
}

update_tool() {
  local tool="$1"
  local repo="$2"
  local asset_regex="$3"
  local nix_file="$4"

  echo "[update-tools] ${tool}" >&2
  local json
  json=$(latest_release "$repo")

  local tag
  tag=$(echo "$json" | jq -r .tag_name)
  local version
  version="${tag#v}"

  local asset
  asset=$(echo "$json" | jq -r --arg re "$asset_regex" '.assets[] | select(.name|test($re)) | .browser_download_url' | head -1)

  if [[ -z "$asset" ]]; then
    echo "[update-tools] no asset matched for ${tool} (${asset_regex})" >&2
    return 1
  fi

  local hash
  hash=$(prefetch_hash "$asset")

  update_nix_file "$nix_file" "$version" "$asset" "$hash"
}

update_tool summarize "steipete/summarize" "summarize-macos-arm64-v[0-9.]+\\.tar\\.gz" "$repo_root/nix/pkgs/summarize.nix"
update_tool gogcli "steipete/gogcli" "gogcli_[0-9.]+_darwin_arm64\\.tar\\.gz" "$repo_root/nix/pkgs/gogcli.nix"
update_tool camsnap "steipete/camsnap" "camsnap-macos-arm64\\.tar\\.gz" "$repo_root/nix/pkgs/camsnap.nix"
update_tool sonoscli "steipete/sonoscli" "sonoscli-macos-arm64\\.tar\\.gz" "$repo_root/nix/pkgs/sonoscli.nix"
update_tool bird "steipete/bird" "bird-macos-universal-v[0-9.]+\\.tar\\.gz" "$repo_root/nix/pkgs/bird.nix"
update_tool peekaboo "steipete/peekaboo" "peekaboo-macos-universal\\.tar\\.gz" "$repo_root/nix/pkgs/peekaboo.nix"
update_tool poltergeist "steipete/poltergeist" "poltergeist-macos-universal-v[0-9.]+\\.tar\\.gz" "$repo_root/nix/pkgs/poltergeist.nix"
update_tool sag "steipete/sag" "sag_[0-9.]+_darwin_universal\\.tar\\.gz" "$repo_root/nix/pkgs/sag.nix"
update_tool imsg "steipete/imsg" "imsg-macos\\.zip" "$repo_root/nix/pkgs/imsg.nix"

# Oracle is more complex (pnpm lock + offline deps). Keep manual for now.
# update_tool oracle "steipete/oracle" "oracle-[0-9.]+\\.tgz" "$repo_root/nix/pkgs/oracle.nix"

