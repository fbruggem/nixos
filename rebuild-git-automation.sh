#!/usr/bin/env bash
set -euo pipefail

cd /home/fbruggem/nixos

echo "[nixos-config-update] Fetching latest config..."
if ! git fetch --quiet; then
  echo "Git fetch failed!"
  exit 1
fi

# If nothing new, exit
if git diff --quiet HEAD..@{u}; then
  echo "No updates found."
  exit 0
fi

echo "Changes detected, pulling..."
git pull --ff-only

echo "Rebuilding NixOS..."
nixos-rebuild switch -I nixos-config=/home/fbruggem/nixos/configuration.nix

echo "Update + rebuild complete!"
