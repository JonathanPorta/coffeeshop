#!/bin/bash

PORT=$1

BINDING_ROOT=$(pwd)
NODE_PATH='$BINDING_ROOT/code/node/bin'
VALHALLA_PATH='$BINDING_ROOT/files'

PATH=$PATH:NODE_PATH
npm install
bower install
grunt
#symlink to valhalla
node ./src/server/start.js $1
