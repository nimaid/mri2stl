#!/bin/bash
FILENAME=$1
BASENAME=$(basename $FILENAME)
SCANNAME=${BASENAME%%.*}

PRINTDIR=/3dprintscript
NEWDIR=$PRINTDIR/scans/$SCANNAME
LOGFILE=$PRINTDIR/${SCANNAME}_log.txt

if [ $# -ne 1 ]
then
  echo "ERROR: nii2stl takes exactly 1 argument, the path to a .nii file."
else
    if [[ $BASENAME == *.nii ]]
    then
        (
        # Clean folder
        if [ ! -d $NEWDIR ]
        then
            mkdir -v -p $NEWDIR/input
        else
            rm -v -rf $NEWDIR/*
            mkdir -v $NEWDIR/input
        fi
        
        # Copy the .nii to the correct place
        cp -v $FILENAME $NEWDIR/input/struct.nii
        
        # Convert the prepared file to an .stl file
        mri2stl $SCANNAME
        ) |& tee $LOGFILE
        printf "\n[nii2stl] Saved all output to \"%s\".\n" $LOGFILE
    else
        echo "File is not a *.nii file."
    fi
fi
