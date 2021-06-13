#!/bin/bash
#
# Rclone script to archive Jeff Geerling's most important data to an Amazon S3
# Glacier Deep Archive-backed bucket.
#
# Basic usage:
#   ./rclone.sh
#
# Script requires valid credentials - set up with `rclone config`.

# Check if rclone is installed.
if ! [ -x "$(command -v rclone)" ]; then
  echo 'Error: rclone is not installed.' >&2
  exit 1
fi

# Variables.
rclone_remote=personal
rclone_s3_bucket=jg-archive
show_progress=true
bandwidth_limit=23M

# Make sure bucket exists.
rclone mkdir $rclone_remote:$rclone_s3_bucket

# TODO
# Back up "Video Projects" directory from Jeff's Mac mini.
#
# Also, consider having a bit in this script which auto-mounts the volume if it
# isn't already mounted (using whatever macOS terminal command is necessary).
#
# Example: `open 'smb://username:password@server/share'`

# List of directories to clone. MUST be absolute path, beginning with /.
declare -a dirs=(
  "/Volumes/Brachiosaur/Presentation Recordings"
  "/Volumes/Brachiosaur/Timelapses"
  "/Volumes/Brachiosaur/YouTube Videos"
  "/Volumes/Brachiosaur/Old School Files"
  "/Volumes/Brachiosaur/Old Websites"
  "/Volumes/T-Rex/Home Movies"
  "/Volumes/Media/Movies"
  "/Volumes/Media/TV Shows"
)

# Clone each directory.
for i in "${dirs[@]}"
do
  echo "Syncing Directory: $i"
  despaced="${i// /_}"
  rclone sync "$i" $rclone_remote:$rclone_s3_bucket"$despaced" --skip-links --progress --bwlimit $bandwidth_limit
done
