#!/bin/sh

sedargs() {
   for i in c cc cpp m mm asm S; do
      echo "-e s/\.$i$/.o/"
   done
}

(for i in "$@"; do echo $i; done) | sed `sedargs`
