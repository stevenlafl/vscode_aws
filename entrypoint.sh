#!/bin/sh

echo 'entrypoint of IDE'	

dumb-init code-server --host 0.0.0.0 --auth none --disable-telemetry --disable-updates 