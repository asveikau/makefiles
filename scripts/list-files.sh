#!/bin/sh

git ls-files | grep -v ^.gitmodules | grep -v ^submodules/

# --recurse-submodules missing on OS X, hence a gross hack:
#
git submodule foreach --quiet 'git ls-files | sed "s|^|$path/|"'
