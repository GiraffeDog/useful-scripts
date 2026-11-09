#!/bin/bash
set -euo pipefail

volume="/Volumes/Expansion"
destination="$volume/Backups/iPhotos-iCloud"
python="/Library/Frameworks/Python.framework/Versions/3.13/bin/python3.13"
venv="$HOME/.venvs/icloudpd-py313"
downloader="$venv/bin/icloudpd"

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

[[ $# -le 1 ]] || die "Usage: bash $0 [Apple Account email]"
/sbin/mount | /usr/bin/grep -F " on $volume (" >/dev/null ||
  die "Expansion is not mounted at $volume. Connect the drive and try again."
cd "$volume"

account="${1:-}"
if [[ -z "$account" ]]; then
  read -r -p "Apple Account email: " account
fi
[[ -n "$account" ]] || die "Enter your Apple Account email."

[[ -x "$python" ]] || die "Python 3.13 was not found at $python."
if [[ ! -x "$venv/bin/python3.13" ]]; then
  "$python" -I -m venv "$venv"
fi

"$venv/bin/python3.13" -I -c 'import sys; sys.exit(sys.version_info[:2] != (3, 13))' ||
  die "The environment at $venv is not running Python 3.13. Move it aside and rerun this script."

if [[ ! -x "$downloader" ]]; then
  "$venv/bin/python3.13" -I -m pip install 'icloudpd==1.33.0'
fi

mkdir -p "$destination"
printf 'Downloading iCloud originals to %s\n' "$destination"
exec /usr/bin/caffeinate -i "$downloader" \
  --username "$account" \
  --directory "$destination" \
  --size original
