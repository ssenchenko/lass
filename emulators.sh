#!/bin/bash
set -e

firebase experiments:enable webframeworks
npm i # if done as a part of container seteup, rollup is not found
firebase emulators:start --only firestore,hosting
