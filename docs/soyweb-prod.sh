#!/usr/bin/env bash

# Always run this script from the root of the Buck project directory.
cd "$(git rev-parse --show-toplevel)/docs" || exit
exec java -jar plovr-81ed862.jar soyweb --port 9814 --dir . --globals globals.json
