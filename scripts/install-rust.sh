#!/usr/bin/env -S bash -xv


# Install latest rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
sh /tmp/rustup.sh -y -c rust-analyzer
