#!/bin/sh

appname=${APPNAME-`basename $(git rev-parse --show-toplevel)`}
script_path="`echo $0 | sed -e 's|[^/]*$||'`"
config="$1"

# Sketchy business, but we are pushing code to hetereogenous VMs on a LAN
# which get their address from DHCP, so host verification becomes noise.
#
sshopts="-o StrictHostKeyChecking=no"

artifacts() {
   for i in $appname *.dSYM *.debug *.pdb *.app *.dmg *.exe lib*.a *.lib; do
      [ -f "$i" -o -d "$i" ] && [ "$i" != "$appname.exe" ] && echo $i
   done
}

if [ $config = "--perform" ]; then

   gmake=`$script_path/find-gmake.sh`
   ncpu=`$script_path/ncpu.sh`

   rm -rf out

   [ "$SUBDIR" = '' ] && unset SUBDIR
   oldwd="`pwd`"
   cd ${SUBDIR-"$oldwd"}

   rm -rf out
   mkdir -p out

   case `uname -s` in
      MSYS*)
         mkdir -p out/x86
         mkdir -p out/amd64

         $gmake -j $ncpu UNDER_CI=y && \
         rm -f vc140.pdb && \
         cp -r `artifacts` out/x86 && \
         $gmake clean && \
         sleep 5 && \
         $gmake -j $ncpu WIN64=y UNDER_CI=y && \
         rm -f vc140.pdb && \
         cp -r `artifacts` out/amd64
         ;;
      *)
         $gmake -j $ncpu UNDER_CI=y && \
         cp -r `artifacts` out/
         ;;
   esac

   status=$?

   cd "$oldwd"
   [ "$SUBDIR" != '' ] && mv "$SUBDIR"/out .

   exit $status
else

   my_toplevel="`git rev-parse --show-toplevel`"
   submodule_breakout="`cd .. ; git rev-parse --show-toplevel 2>/dev/null`"
   [ "$submodule_breakout" = '' ] && unset submodule_breakout
   oldwd="`pwd`"
   cd ${submodule_breakout-"$oldwd"}

   if [ "$submodule_breakout" != '' ]; then
      subdir="`echo $my_toplevel | sed -e s\|^$submodule_breakout[/]*\|\|`"
      script_path=$subdir/$script_path
   fi

   tarfile=archive.tar
   rm -f "$tarfile"
   tar cf "$tarfile" `$script_path/list-files.sh`

   # old code to pack up 'scripts' dir on the other side...
   #tar rf "$tarfile" -C "`dirname $script_path`" "`basename $script_path`"
   #remote_script_path="`basename $script_path`"

   # don't care about that anymore in the era of the "submodule breakout"
   remote_script_path="$script_path"

   for config in "$@"; do
      rm -rf ${subdir-.}/out/"$config"
      mkdir -p ${subdir-.}/out/"$config"

      if [ "`echo $config|grep -ci ^win`" != 0 ]; then
         winprefix="sh -c 'eval \$@' --"
      fi

      workpath="work/$config"
      (ip=`$script_path/bcast.pl -n "$config"` && \
      ssh $sshopts user@$ip $winprefix 'rm -rf '"$workpath"' && mkdir -p '"$workpath"' && cd '"$workpath"' && tar xf - && env APPNAME='"$appname"' SUBDIR='"$subdir"' sh '"$remote_script_path"'/remote-build.sh --perform' < "$tarfile" && \
      scp $sshopts -r user@$ip:"$workpath/out" ${subdir-.}/out/"$config" && \
      mv ${subdir-.}/out/"$config"/out/* ${subdir-.}/out/"$config" && \
      rmdir ${subdir-.}/out/"$config"/out) &
   done

   wait
   rm -f "$tarfile"

   cd "$oldwd"
fi

