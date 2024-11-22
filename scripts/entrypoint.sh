#!/bin/sh

chown --recursive developer:developer /srv/*

exec su-exec developer "$@"
