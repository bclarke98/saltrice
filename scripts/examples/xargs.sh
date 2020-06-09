#!/usr/bin/env sh
echo {0..11} | xargs -n 3 printf "%s_%s_%s\n"
# whoami | xargs -I{} ssh {}@10.0.1.1
