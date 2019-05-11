#!/bin/bash
if [ $# -ne 1 ]
then
  echo "ERROR: nii2stl takes exactly 1 argument, the path to a .nii file."
else
    FILENAME=$1
    BASENAME=$(basename $FILENAME)
    SCANNAME=${BASENAME%%.*}

    PRINTDIR=/3dprintscript
    NEWDIR=$PRINTDIR/scans/$SCANNAME

    if [[ $BASENAME == *.nii ]]
    then
        # Move the .nii to the correct place
        mkdir -p $NEWDIR/input
        mv $FILENAME $NEWDIR/input/struct.nii
        
        # Convert the .nii file to an .stl file
        $PRINTDIR/mri2stl.sh $SCANNAME
    else
        echo "File is not a *.nii file."
    fi
fi
