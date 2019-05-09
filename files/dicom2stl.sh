#!/bin/bash
FILENAME=$1
BASENAME=$(basename $FILENAME)
SCANNAME=${BASENAME%%.*}

PRINTDIR=/3dprintscript
NEWDIR=$PRINTDIR/scans/$SCANNAME

if [[ $BASENAME == *.zip ]]
then
    mkdir -p $NEWDIR
    mv $FILENAME $NEWDIR
    unzip $NEWDIR/$BASENAME -d $NEWDIR
    rm $NEWDIR/$BASENAME
    
    dcm2niix $NEWDIR
    mkdir -p $NEWDIR/input
    mv $NEWDIR/*.nii $NEWDIR/input/struct.nii
    rm $NEWDIR/*

    $PRINTDIR/mri2stl.sh $SCANNAME

    #mv $NEWDIR/output/final_s.stl $PRINTDIR/brain_$SCANNAME.stl
else
    echo "File is not a *.zip file."
fi