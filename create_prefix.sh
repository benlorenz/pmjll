#!/bin/bash

set -e

usage() { echo "Usage: $0 [-a arch] [-j julia] [-p prefix]" 1>&2; exit 1; }

basedir=$(dirname $0)
prefix=$basedir/prefix
julia=julia
arch="x86_64"

args=`getopt a:j:p:h $*`
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
      -h)
         usage; exit 1;
         ;;
      --)
         shift; break
         ;;
   esac
done

prefix=$prefix.$arch

cd $basedir

$julia populate_prefix.jl "$prefix" "$arch"

patch -d $prefix -p1 < pm_prefix_new.patch

mkdir -p $prefix/deps/
for name in FLINT_jll GMP_jll MPFR_jll PPL_jll Perl_jll SCIP_jll bliss_jll boost_jll cddlib_jll lrslib_jll normaliz_jll; do 
   ln -s ../ $prefix/deps/$name
done

