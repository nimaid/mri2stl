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
        
        # Run FreeSurfer on the .nii file
        $PRINTDIR/mri2stl.sh $SCANNAME
        
        # Copy the final output to the main directory
        cp $NEWDIR/output/final_s.stl $PRINTDIR/brain_$SCANNAME.stl
    else
        echo "File is not a *.nii file."
    fi
fi
