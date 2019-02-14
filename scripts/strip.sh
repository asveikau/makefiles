#!/bin/sh

# Invoke strip(1) while keeping debug symbols in a separate file.

binfile="$1"

if [ "`uname -s`" = Darwin ]; then
   debugfile="$binfile".dSYM
   rm -rf "$debugfile"
   dsymutil "$binfile" -o "$debugfile" && \
   strip "$binfile"
else
   debugfile="$binfile".debug
   objcopy --only-keep-debug "$binfile" "$debugfile" && \
   strip "$binfile" && \
   objcopy --add-gnu-debuglink="$debugfile" "$binfile"
fi
