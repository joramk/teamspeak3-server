#!/bin/bash
set -e
JSON=$(wget -q -O - https://www.teamspeak.com/versions/server.json)
echo $JSON | jq -r ".linux.x86_64.version"

