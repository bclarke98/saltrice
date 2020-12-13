#!/usr/bin/env sh
find . -name '*.mkv' -exec bash -c 'echo "$0: $(basename "$0")"' {} \;
