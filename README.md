# ShellBeats YouTube Playlist Sync

Sync YouTube (or YouTube Music) playlists for use with [ShellBeats](https://github.com/ShellBeats).

The script fetches metadata from each specified playlist and generates ShellBeats-compatible JSON files in `~/.shellbeats/playlists/`.

## Requirements

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [jq](https://jqlang.github.io/jq/)
- [ShellBeats](https://github.com/ShellBeats)
- [Chromium](https://www.chromium.org/)
- [Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc) (Chromium extension)

## Setup

Before running the script, follow these steps:

1. **Install Chromium** if you don't have it already.
2. **Install the extension** [Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc) in Chromium.
3. **Open [YouTube Music](https://music.youtube.com) or [YouTube](https://www.youtube.com)** in Chromium and log in to your account.
4. **Export your cookies** using the extension: click the extension icon and save the file as `cookies.txt` in the project root.

> **Note:** Do not commit `cookies.txt` to public repositories. Make sure it is listed in `.gitignore`.

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
