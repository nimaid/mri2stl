#!/bin/bash
FILENAME=$1
BASENAME=$(basename $FILENAME)
SCANNAME=${BASENAME%%.*}

PRINTDIR=/3dprintscript
NEWDIR=$PRINTDIR/scans/$SCANNAME
LOGFILE=$PRINTDIR/${SCANNAME}_log.txt
DICOMDIR=$NEWDIR/dicom

if [ $# -ne 1 ]
then
  echo "ERROR: dicom2stl takes exactly 1 argument, the path to a .zip file of DICOM images."
else
    if [[ $BASENAME == *.zip ]]
    then
        (
        # Move, unzip, and delete DICOM image archive
        mkdir -v -p $DICOMDIR
        mv -v $FILENAME $NEWDIR
        unzip $NEWDIR/$BASENAME -d $DICOMDIR
        rm -v $NEWDIR/$BASENAME
        
        # Convert the DICOM images to a .nii file
        dcm2niix $DICOMDIR
        
        # Move the .nii to the correct place
        mkdir -v -p $NEWDIR/input
        mv -v $DICOMDIR/*.nii $NEWDIR/input/struct.nii
        
        # Remove DICOM images
        rm -v -r $DICOMDIR
        
        # Convert the prepared file to an .stl file
        mri2stl $SCANNAME
        ) |& tee $LOGFILE
        printf "\n[dicom2stl] Saved all output to \"%s\".\n" $LOGFILE
    else
        echo "File is not a *.zip file."
    fi
fi
