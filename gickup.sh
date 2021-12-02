#!/bin/bash
#
# gickup script to archive Jeff Geerling's GitHub repositories locally.
#
# Basic usage:
#   ./gickup.sh
#
# Script requires valid credentials - set up following gickup's README, in the
# format below:
#
# ```
# source:
#   github:
#     - token: [redacted]  # generate an personal access token in dev settings
#       user: geerlingguy
#       username: geerlingguy
#       ssh: true
#       sshkey: /home/pi/.ssh/id_ed25519  # must be added to your GitHub account
#       exclude:
#         - linux
# destination:
#   local:
#     - path: "/Volumes/Git-Backups"
# ```

GICKUP=/usr/local/bin/gickup
KNOWN_HOSTS=~/.ssh/known_hosts

# Make sure a known_hosts file exists.
if [ ! -f "$KNOWN_HOSTS" ]; then
  echo 'Generating known_hosts file.'
  ssh-keyscan github.com >> $KNOWN_HOSTS
fi

# Check if gickup is installed.
if ! [ -x "$(command -v $GICKUP)" ]; then
  echo 'Error: gickup is not installed.' >&2
  exit 1
fi

$GICKUP ~/.gickup.yml
