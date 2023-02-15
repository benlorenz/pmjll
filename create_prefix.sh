#!/bin/bash

set -e

basedir=$(dirname $0)
prefix=$basedir/prefix

cd $basedir

julia prepare_prefix.jl

patch -d $prefix -p1 < pm_prefix_new.patch

mkdir -p $prefix/deps/
for name in FLINT_jll GMP_jll MPFR_jll PPL_jll Perl_jll SCIP_jll bliss_jll boost_jll cddlib_jll lrslib_jll normaliz_jll; do 
   ln -s ../ $prefix/deps/$name
done

