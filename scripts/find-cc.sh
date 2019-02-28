#!/bin/sh

lang="$1"
shift

case "$lang" in
c++)
   ext=cc
   ;;
*)
   ext=c
   ;;
esac

testprogram_c() {
   cat << "EOF"
#include <stdio.h>
int main() { puts("Hello World!"); return 0; }
EOF
}

testprogram_cc() {
   cat << "EOF"
// XXX
#if defined(__sun__)
#define __STRICT_ANSI__ 1
#endif

#include <vector>
#include <new>
int main() {
   std::vector<int> a;
   try
   {
      a.push_back(256);
   }
   catch (std::bad_alloc)
   {
   }
}
EOF
}

testprogram=/tmp/test$$.$ext
testprogram_$ext > $testprogram

for i in "$@" "$lang"; do
   "$i" -o /dev/null "$testprogram" 2>/dev/null && \
      echo "$i" && \
      rm -f "$testprogram" && \
      exit 0
done

rm -f "$testprogram"
echo 'Could not find compiler. Tried:' "$@" "$lang" 1>&2
exit 1
