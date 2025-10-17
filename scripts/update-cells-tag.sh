#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
  cat <<USAGE
Usage: $(basename "$0") <owner/repo> <tag>
Example: $(basename "$0") pydio/cells v4.5.0

Outputs:
  * commit hash for the tag
  * build stamp (current UTC time)
  * nix-prefetch-url command for source hash
USAGE
  exit 1
fi

REPO="$1"
TAG="$2"

url="https://github.com/${REPO}.git"
commit=$(git ls-remote "$url" "refs/tags/${TAG}" | awk '{print $1}')
if [ -z "$commit" ]; then
  echo "Could not resolve tag ${TAG} on ${REPO}" >&2
  exit 2
fi

stamp=$(TZ=UTC date -u '+%Y-%m-%dT%H:%M:%SZ')
source_url="https://github.com/${REPO}/archive/refs/tags/${TAG}.tar.gz"

hash=$(nix-prefetch-url --unpack "$source_url")

cat <<RESULT
Tag metadata
============
Tag:          ${TAG}
Commit:       ${commit}
Build stamp:  ${stamp}
Source URL:   ${source_url}
Nix sha256:   ${hash}

Update steps
------------
1. Edit nix/metadata.nix with the values above.
2. Set vendorHash to lib.fakeSha256 (or null).
3. Run: nix build .#cells --no-write-lock-file
4. Replace vendorHash with the value from the build error and rebuild.
RESULT
