#!/bin/sh

case `uname -s` in
Darwin|FreeBSD|OpenBSD|NetBSD)
   sysctl hw.ncpu | sed s/[^0-9]*//
   ;;
Linux)
   grep -c ^processor /proc/cpuinfo
   ;; 
MSYS_NT*)
   echo $NUMBER_OF_PROCESSORS
   ;;
*)
   echo 1
esac
