#!/usr/bin/env sh

# Select region → capture → send PNG directly to clipboard
slurp | grim -g - - | wl-copy

