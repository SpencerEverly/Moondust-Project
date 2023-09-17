#!/bin/bash

reponame=$(basename `git rev-parse --show-toplevel`)
echo "-----------------------------------"
echo "Updating repo $reponame"
if [[ "$reponame" == "LuaJIT" ]]; then
    echo "Branch v2.1"
    git checkout v2.1
    git pull origin v2.1
elif [[ "$reponame" == "libpng" ]]; then
    echo "Branch moondust"
    git checkout moondust
    git pull origin moondust
elif [[ "$reponame" == "harfbuzz" || "$reponame" == "libjpeg" ]]; then
    echo "Branch main"
    git checkout main
    git pull origin main
else
    echo "Branch smbxplus"
    git checkout smbxplus
    git pull origin smbxplus
fi
