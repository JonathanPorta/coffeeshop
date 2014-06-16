#!/bin/bash

BINDING_ROOT=$HOME

INSTALL_LOG="$BINDING_ROOT/logs/install.log"
NODE_LOG="$BINDING_ROOT/logs/node.log"

NODE_PATH="$BINDING_ROOT/code/node/bin"
FILES_PATH="$BINDING_ROOT/files"

PATH=$PATH:$NODE_PATH

echo "BINDING_ROOT=$BINDING_ROOT" > $INSTALL_LOG
echo "INSTALL_LOG=$INSTALL_LOG" >> $INSTALL_LOG 2>&1
echo "NODE_LOG=$NODE_LOG" >> $INSTALL_LOG 2>&1
echo "FILES_PATH=$FILES_PATH" >> $INSTALL_LOG 2>&1
echo "PATH=$PATH" >> $INSTALL_LOG 2>&1

mkdir -p $FILES_PATH/node_modules
mkdir -p $FILES_PATH/bower_components
mkdir -p $FILES_PATH/build
mkdir -p $FILES_PATH/jefri
mkdir -p $FILES_PATH/uploads

npm cache clean >> $INSTALL_LOG 2>&1
npm install --no-bin-links >> $INSTALL_LOG 2>&1

bower cache clean
bower install >> $INSTALL_LOG 2>&1

grunt >> $INSTALL_LOG 2>&1

node ./src/server/start.js $APPSERVER_PORT $PUBLIC_IP >> $NODE_LOG 2>&1
