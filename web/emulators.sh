#!/usr/bin/env bash
set -euo pipefail

export FIREBASE_CLI_EXPERIMENTS=webframeworks

exec firebase emulators:start --only apphosting,auth,firestore,ui
