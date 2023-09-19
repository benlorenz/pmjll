#!/bin/bash

set -e

usage() { echo "Usage: $0 [-a arch] [-j julia] [-p prefix]" 1>&2; exit 1; }

basedir=$(dirname $0)
prefix=/tmp/pmjll
julia=julia
arch="x86_64"
os="darwin"

args=`getopt a:j:p:o:h $*`
set -- $args
while :; do
   case "$1" in
      -a)
         arch="$2"
         shift; shift
         ;;
      -j)
         julia="$2"
         shift; shift
         ;;
      -p)
         prefix="$2"
         shift; shift
         ;;
      -o)
         os="$2"
         shift; shift
         ;;
      -h)
         usage; exit 1;
         ;;
      --)
         shift; break
         ;;
   esac
done

cd $basedir

fullprefix=$prefix/$os-$arch
if [ "$os" = "macos" ]; then
   fullarch="darwin.$arch"
else
   fullarch=$arch
fi

$julia populate_prefix.jl --prefix "$prefix" --arch "$arch" --os "$os"

version=$(grep 'Version=.*;' $fullprefix/bin/polymake-config | sed -e 's/^.*=\(.*\);/\1/')

sed -e "s/PMJLL_ARCH/$fullarch/g;" \
    -e "s/PMJLL_VERSION/$version/g" \
    pm_prefix_new.patch | patch -d $fullprefix -p1
if [ "$os" = "macos" ]; then
   perl -pi -e 's/-fopenmp//g' $fullprefix/lib/polymake/config*
fi

mkdir -p $fullprefix/deps/
for name in FLINT_jll GMP_jll MPFR_jll PPL_jll Perl_jll SCIP_jll bliss_jll boost_jll cddlib_jll lrslib_jll normaliz_jll; do 
   ln -s ../ $fullprefix/deps/$name
done

