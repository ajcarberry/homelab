#!/bin/bash -eux

# Apt cleanup.
apt autoremove -y
apt update

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
