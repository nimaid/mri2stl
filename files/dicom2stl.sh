#!/bin/bash
if [ $# -ne 1 ]
then
  echo "ERROR: dicom2stl takes exactly 1 argument, the path to a .zip file of DICOM images."
else
    FILENAME=$1
    BASENAME=$(basename $FILENAME)
    SCANNAME=${BASENAME%%.*}

    PRINTDIR=/3dprintscript
    NEWDIR=$PRINTDIR/scans/$SCANNAME

    if [[ $BASENAME == *.zip ]]
    then
        # Move, unzip, and delete DICOM image archive
        mkdir -p $NEWDIR
        mv $FILENAME $NEWDIR
        unzip $NEWDIR/$BASENAME -d $NEWDIR
        rm $NEWDIR/$BASENAME
        
        # Convert the DICOM images to a .nii file
        dcm2niix $NEWDIR
        
        # Move the .nii to the correct place
        mkdir -p $NEWDIR/input
        mv $NEWDIR/*.nii $NEWDIR/input/struct.nii
        
        # Remove DICOM images
        rm $NEWDIR/*
        
        # Run FreeSurfer on the .nii file
        $PRINTDIR/mri2stl.sh $SCANNAME
        
        # Copy the final output to the main directory
        cp $NEWDIR/output/final_s.stl $PRINTDIR/brain_$SCANNAME.stl
    else
        echo "File is not a *.zip file."
    fi
fi
