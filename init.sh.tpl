#!/bin/bash

cd /home/ubuntu/environment
. ~/.bashrc
./provision.sh 
cd /home/ubuntu/app
node app.js
