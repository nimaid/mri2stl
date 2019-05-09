#!/bin/bash
FILENAME=$1
BASENAME=$(basename $FILENAME)
SCANNAME=${BASENAME%%.*}

PRINTDIR=/3dprintscript
NEWDIR=$PRINTDIR/scans/$SCANNAME

mkdir -p $NEWDIR/input
mv $FILENAME $NEWDIR/input/struct.nii

$PRINTDIR/mri2stl.sh $SCANNAME

#mv $NEWDIR/output/final_s.stl $PRINTDIR/brain_$SCANNAME.stl