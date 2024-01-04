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
#       username: geerlingguy
#       ssh: true
#       sshkey: /home/pi/.ssh/id_ed25519  # must be added to your GitHub account
#       exclude:
#         - linux
#       excludeorgs:
#         - ansible-community
#         - operator-framework
#         - ansible-collections
#         - GitHub-Stars
#         - Diodes-Delight
#         - raspberrypi
# destination:
#   local:
#     - path: "/Volumes/Git-Backups"
# ```
#
# For the Personal Access Token, make sure you add the entire `repo` scope if
# you want to replicate private repositories.

GICKUP=/usr/local/bin/gickup

# Check if gickup is installed.
if ! [ -x "$(command -v $GICKUP)" ]; then
  echo 'Error: gickup is not installed.' >&2
  exit 1
fi

$GICKUP ~/.gickup.yml
