#!/bin/bash
set -e

# setup ros environment
source "/knowrob_ws/devel/setup.bash" --
exec "$@"
