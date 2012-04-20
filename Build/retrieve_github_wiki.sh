#!/bin/sh
#
# Clones the wiki from GitHub
#
# christian.heinrich@cmlh.id.au
#
rm -rf ../Maltego-Rapleaf.wiki
cd ..
git clone git@github.com:cmlh/Maltego-Rapleaf.wiki
cd Build
