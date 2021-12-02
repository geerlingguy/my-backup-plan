#!/bin/bash
#
# gickup script to archive Jeff Geerling's GitHub repositories locally.
#
# Basic usage:
#   ./gickup.sh
#
# Script requires valid credentials - set up following gickup's README.

# TODO: Run this command if the known_hosts file doesn't already exist.
# ssh-keyscan github.com >> ~/.ssh/known_hosts

GICKUP=/usr/local/bin/gickup

# Check if gickup is installed.
if ! [ -x "$(command -v $GICKUP)" ]; then
  echo 'Error: gickup is not installed.' >&2
  exit 1
fi

$GICKUP ~/.gickup.yml
