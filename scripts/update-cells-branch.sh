#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
  cat <<USAGE
Usage: $(basename "$0") <owner/repo> <branch>
Example: $(basename "$0") pydio/cells v5-dev

Fetches the HEAD commit for the branch, computes the tarball hash, and prints the metadata snippet for nix/metadata.nix.
USAGE
  exit 1
fi

REPO="$1"
BRANCH="$2"

url="https://github.com/${REPO}.git"
commit=$(git ls-remote "$url" "refs/heads/${BRANCH}" | awk '{print $1}')
if [ -z "$commit" ]; then
  echo "Could not resolve branch ${BRANCH} on ${REPO}" >&2
  exit 2
fi

stamp=$(TZ=UTC date -u '+%Y-%m-%dT%H:%M:%SZ')
source_url="https://github.com/${REPO}/archive/${commit}.tar.gz"

hash=$(nix-prefetch-url --unpack "$source_url")

cat <<'SNIPPET'
Example metadata snippet:
-------------------------
SNIPPET
cat <<SNIPPET
{
  version = "${BRANCH}-$(date -u '+%Y%m%d')";
  buildStamp = "${stamp}";
  source = {
    owner = "${REPO%%/*}";
    repo = "${REPO##*/}";
    rev = "${commit}";
    sha256 = "${hash}";
  };
  vendorHashes = {
    cells = "lib.fakeSha256"; # replace after build
  };
}
SNIPPET

echo "Next steps"
echo "-----------"
echo "1. Update nix/metadata.nix with the snippet above."
echo "2. Run: nix build .#cells-nightly --no-write-lock-file"
echo "3. Capture the vendor hash from the failure output and update metadata."
echo "4. Rebuild to verify, then commit."
