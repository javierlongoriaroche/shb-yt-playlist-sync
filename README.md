# ShellBeats YouTube Playlist Sync

Sync YouTube (or YouTube Music) playlists for use with [ShellBeats](https://github.com/ShellBeats).

The script fetches metadata from each specified playlist and generates ShellBeats-compatible JSON files in `~/.shellbeats/playlists/`.

## Requirements

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [jq](https://jqlang.github.io/jq/)
- [ShellBeats](https://github.com/ShellBeats)

## Configuration

### `playlist.txt`

File listing the playlists to sync, one per line, in the following format:

```
name|url
```

Example:

```
lofi-beats|https://www.youtube.com/playlist?list=PLxxxxxx
synthwave|https://music.youtube.com/playlist?list=PLyyyyyy
```

### `cookies.txt`

Browser cookies file, required by `yt-dlp` to access private or age-restricted playlists. You can export it with extensions like [Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc).

> **Note:** Do not commit `cookies.txt` to public repositories. Make sure it is listed in `.gitignore`.

## Usage

```sh
./sync-yt-playlist.sh
```

The script will:

1. Read the playlists defined in `playlist.txt`.
2. Fetch metadata for each one using `yt-dlp`.
3. Generate a JSON file per playlist in `~/.shellbeats/playlists/`.
4. Update the index at `~/.shellbeats/playlists.json`.
5. Launch ShellBeats.

## Output structure

```
~/.shellbeats/
├── playlists.json          # Playlist index
└── playlists/
    ├── lofi-beats.json
    └── synthwave.json
```
