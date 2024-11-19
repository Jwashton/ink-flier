#!/bin/sh

chown -R developer:developer /workspaces

exec su-exec developer "$@"
