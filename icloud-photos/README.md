# iCloud Photos downloader

Download originals from your personal iCloud Photos library directly to a mounted drive. The script uses [icloudpd](https://github.com/icloud-photos-downloader/icloud_photos_downloader) in copy mode.

## Requirements

- macOS and Python 3.13. The script uses the python.org installation at `/Library/Frameworks/Python.framework/Versions/3.13/bin/python3.13`. If yours is elsewhere, edit the `python` setting in the script.
- An external drive with enough free space. The default mount point is `/Volumes/Expansion` and the destination is `Backups/iPhotos-iCloud` on that drive. Edit `volume` and `destination` if needed.
- Internet access and an Apple Account that can access iCloud Photos. See the [upstream authentication guide](https://icloud-photos-downloader.github.io/icloud_photos_downloader/authentication.html) for web access and account settings.

## Run

From this directory:

```bash
bash ./download-icloud-photos.sh
```

Enter your Apple Account email, then follow the password and verification prompts if shown. The script creates a dedicated Python environment under `~/.venvs/icloudpd-py313`, installs the pinned downloader if needed, and keeps the Mac awake while the download runs.

## Long downloads and interrupted runs

For a long download, start `screen -S icloud-photos` before running the script. Press **Ctrl+A**, then **D** to detach. Reconnect with `screen -r icloud-photos` to see progress. The progress count includes items the downloader checks and skips because they are already on disk.

If interrupted, run the same script again with the same account and destination. Review the terminal output for any errors when it finishes.

## What gets copied

The script requests original files from the personal library. Live Photos can produce a still image and a video file. Shared Photo Library requires a separate run configured for that library. This script requests the original Cinematic video without a separate baked-in rendition. Verify the editable depth and focus tracks on a known Cinematic clip before relying on the archive for those edits.
