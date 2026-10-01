#!/bin/bash
# Installs the latest Kerf from GitHub into /Applications, without Gatekeeper's "could not verify" wall.
# Kerf is ad-hoc signed and not notarized (that needs a paid Apple developer account). A zip from the
# browser gets a quarantine flag and macOS refuses to open it; curl sets no such flag. To make up for
# that, this script checks the download against the SHA-256 in the release notes and checks the
# signature before it installs anything.
#
#   curl -fsSL https://raw.githubusercontent.com/BEMBOOMER/kerf-releases/main/install.sh | bash
#
# KERF_DEST=/some/dir installs elsewhere; KERF_NO_LAUNCH=1 skips quitting and opening Kerf (for tests).
set -euo pipefail

REPO="BEMBOOMER/kerf-releases"
say() { printf 'Kerf: %s\n' "$*"; }
fail() { printf 'Kerf: %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || fail "Kerf is een app voor macOS."
[ "$(uname -m)" = "arm64" ] || fail "Kerf draait alleen op Macs met Apple silicon."
MAJOR=$(sw_vers -productVersion | cut -d. -f1)
[ "$MAJOR" -ge 14 ] || fail "Kerf vraagt macOS 14 of nieuwer, deze Mac heeft $(sw_vers -productVersion)."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

say "nieuwste versie opzoeken..."
curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" -o "$TMP/release.json" || fail "GitHub is niet bereikbaar."
TAG=$(grep -o '"tag_name": *"[^"]*"' "$TMP/release.json" | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
URL=$(grep -o '"browser_download_url": *"[^"]*\.zip"' "$TMP/release.json" | head -1 | sed 's/.*"\(https[^"]*\)"$/\1/')
SHA=$(grep -o 'sha256 [0-9a-f]\{64\}' "$TMP/release.json" | head -1 | awk '{print $2}')
[ -n "$URL" ] && [ -n "$SHA" ] || fail "De release mist een zip of een controlesom; er is niets geinstalleerd."

say "${TAG#v} downloaden..."
curl -fL --progress-bar "$URL" -o "$TMP/Kerf.zip" || fail "Downloaden lukte niet."
GOT=$(shasum -a 256 "$TMP/Kerf.zip" | awk '{print $1}')
[ "$GOT" = "$SHA" ] || fail "De controlesom klopt niet; er is niets geinstalleerd."

ditto -x -k "$TMP/Kerf.zip" "$TMP/unpacked"
APP="$TMP/unpacked/Kerf.app"
[ -d "$APP" ] || fail "Er zit geen Kerf.app in de download."
codesign --verify --deep --strict "$APP" 2>/dev/null || fail "De handtekening van de app klopt niet; er is niets geinstalleerd."
BUNDLE=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$APP/Contents/Info.plist" 2>/dev/null || true)
[ "$BUNDLE" = "nl.bemboe.kerf" ] || [ "${KERF_ANY_BUNDLE:-}" = 1 ] || fail "Onverwachte app in de download ($BUNDLE)."

DEST="${KERF_DEST:-/Applications}"
if [ ! -w "$DEST" ]; then DEST="$HOME/Applications"; mkdir -p "$DEST"; fi

if [ "${KERF_NO_LAUNCH:-}" != 1 ]; then pkill -x Kerf 2>/dev/null && sleep 0.5 || true; fi
rm -rf "$DEST/Kerf.app"
ditto "$APP" "$DEST/Kerf.app"
xattr -dr com.apple.quarantine "$DEST/Kerf.app" 2>/dev/null || true

if [ "${KERF_NO_LAUNCH:-}" != 1 ]; then open "$DEST/Kerf.app"; fi
say "${TAG#v} staat in $DEST. Wijs naar de notch."
say "Voor de volume- en helderheid-HUD vraagt Kerf om Toegankelijkheid; de rest werkt meteen."
