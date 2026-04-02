#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PLAYLIST_FILE="$SCRIPT_DIR/playlist.txt"
OUTPUT_DIR="$HOME/.shellbeats/playlists"
INDEX_FILE="$HOME/.shellbeats/playlists.json"
COOKIES="$SCRIPT_DIR/cookies.txt"
TMP_DIR="/tmp/shellbeats-sync"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$TMP_DIR"

log() { echo "🎧  $1"; }
success() { echo "✅  $1"; }
error() { echo "❌  $1"; }

UPDATED_PLAYLISTS="[]"

sync_playlist() {
  name="$1"
  url="$2"

  log "Syncing: $name"

  CLEAN_URL=$(echo "$url" | sed 's/music.youtube.com/www.youtube.com/')

  TMP_FILE="$TMP_DIR/$name.json"
  FINAL_FILE="$OUTPUT_DIR/$name.json"

  yt-dlp --cookies "$COOKIES" --flat-playlist -J "$CLEAN_URL" 2>/dev/null \
  | jq -r --arg name "$name" '
  {
    name: $name,
    type: "local",
    is_shared: false,
    songs: [
      .entries[] | {
        title: .title,
        video_id: .id,
        duration: (.duration // 0)
      }
    ]
  }
  ' > "$TMP_FILE"

  if [ ! -s "$TMP_FILE" ]; then
    error "Failed: $name"
    return
  fi

  if [ -f "$FINAL_FILE" ] && cmp -s "$TMP_FILE" "$FINAL_FILE"; then
    success "$name → sin cambios"
    rm "$TMP_FILE"
  else
    mv "$TMP_FILE" "$FINAL_FILE"
    success "$name → actualizado"
  fi

  # Añadir a índice
  UPDATED_PLAYLISTS=$(echo "$UPDATED_PLAYLISTS" | jq --arg name "$name" --arg file "$(basename "$FINAL_FILE")" '
    . + [{name: $name, filename: $file}]
  ')
}

log "🎶 Shellbeats Sync Start"

while IFS="|" read -r name url; do
  [ -z "$name" ] && continue
  sync_playlist "$name" "$url"
done < "$PLAYLIST_FILE"

# 🔥 Actualizar playlists.json
log "📚 Updating playlists index..."

echo "$UPDATED_PLAYLISTS" | jq '{playlists: .}' > "$INDEX_FILE"

success "Index actualizado"

log "🚀 Launching Shellbeats..."
shellbeats