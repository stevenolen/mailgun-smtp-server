#!/bin/bash

bundle exec ruby mail.rb &

# trap SIGTERM (docker stop) and SIGINT (Ctrl-C if container is foreground), deactivate and exit.
# NOTE: docker sends these signals to the backgrounded ps separately, so it will separately.
trap "{ exit 0; }" SIGTERM SIGINT

# infinite loop so container doesn't exit.
while true; do :; done