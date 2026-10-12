#!/usr/bin/env zsh
# Local test helper: installs chrome.css as userChrome.css in a Zen profile and
# enables legacy stylesheet loading via user.js. Quit Zen first, relaunch after.
#
# Profile detection (first match wins):
#   1. $ZEN_PROFILE            explicit path to a profile directory
#   2. profiles.ini            [Install*] Default=<path>   (the profile this Zen install actually uses)
#   3. profiles.ini            the [ProfileN] with Default=1 (legacy marker)
#   4. profiles.ini            the first profile whose Name/Path contains "release"
# Supported: macOS (~/Library/Application Support/zen), Linux (~/.zen).
# Windows: run from Git Bash/WSL with ZEN_PROFILE="%APPDATA%\zen\Profiles\<dir>".
#
# Flags: --dry-run  only print what would be done.
set -euo pipefail
DRY=0; [[ "${1:-}" == "--dry-run" ]] && DRY=1

SRC="$(cd "$(dirname "$0")" && pwd)/chrome.css"
[[ -f "$SRC" ]] || { echo "chrome.css not found next to this script" >&2; exit 1; }

find_root() {
  for d in "$HOME/Library/Application Support/zen" "$HOME/.zen" "$HOME/.var/app/app.zen_browser.zen/.zen"; do
    [[ -f "$d/profiles.ini" ]] && { echo "$d"; return; }
  done
  return 1
}

resolve_profile() {
  if [[ -n "${ZEN_PROFILE:-}" ]]; then echo "$ZEN_PROFILE"; return; fi
  local root; root="$(find_root)" || { echo "profiles.ini not found; set ZEN_PROFILE" >&2; return 1; }
  local ini="$root/profiles.ini"
  # 2. [Install*] Default=<relative path>
  local inst; inst="$(awk -v RS= '/^\[Install[0-9A-F]+\]/{for(i=1;i<=split($0,L,"\n");i++) if(L[i]~/^Default=/){print substr(L[i],9); exit}}' "$ini")"
  if [[ -n "$inst" && -d "$root/$inst" ]]; then echo "$root/$inst"; return; fi
  # 3./4./5. [ProfileN] blocks -> "IsRelative|Path|Name|Default"
  local rows; rows="$(awk -v RS= '
    /^\[Profile[0-9]+\]/ {
      rel=""; path=""; name=""; def="0"
      n=split($0, L, "\n")
      for (i=1;i<=n;i++) {
        if (L[i] ~ /^IsRelative=/) rel=substr(L[i],12)
        if (L[i] ~ /^Path=/)       path=substr(L[i],6)
        if (L[i] ~ /^Name=/)       name=substr(L[i],6)
        if (L[i] ~ /^Default=/)    def=substr(L[i],9)
      }
      print rel "|" path "|" name "|" def
    }' "$ini")"
  local pick
  pick="$(printf '%s\n' "$rows" | awk -F'|' '$4=="1"{print; exit}')"
  [[ -z "$pick" ]] && pick="$(printf '%s\n' "$rows" | awk -F'|' 'tolower($2$3) ~ /release/{print; exit}')"
  [[ -z "$pick" ]] && pick="$(printf '%s\n' "$rows" | head -1)"
  [[ -z "$pick" ]] && { echo "no profiles in $ini" >&2; return 1; }
  local rel path; rel="${pick%%|*}"; path="$(printf '%s' "$pick" | awk -F'|' '{print $2}')"
  if [[ "$rel" == "1" ]]; then echo "$root/$path"; else echo "$path"; fi
}

PROFILE="$(resolve_profile)"
[[ -d "$PROFILE" ]] || { echo "profile dir does not exist: $PROFILE" >&2; exit 1; }
echo "profile: $PROFILE"

if (( DRY )); then
  echo "[dry-run] would copy $SRC -> $PROFILE/chrome/userChrome.css"
  echo "[dry-run] would ensure toolkit.legacyUserProfileCustomizations.stylesheets=true in $PROFILE/user.js"
  exit 0
fi

mkdir -p "$PROFILE/chrome"
if [[ -f "$PROFILE/chrome/userChrome.css" ]]; then
  cp "$PROFILE/chrome/userChrome.css" "$PROFILE/chrome/userChrome.css.bak.$(date +%s)"
fi
cp "$SRC" "$PROFILE/chrome/userChrome.css"
grep -q 'toolkit.legacyUserProfileCustomizations.stylesheets' "$PROFILE/user.js" 2>/dev/null \
  || echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$PROFILE/user.js"
echo "Installed. Quit and relaunch Zen to see the ring."
