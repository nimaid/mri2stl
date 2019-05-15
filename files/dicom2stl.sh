#!/bin/bash
FILENAME=$1
BASENAME=$(basename $FILENAME)
SCANNAME=${BASENAME%%.*}

PRINTDIR=/3dprintscript
NEWDIR=$PRINTDIR/scans/$SCANNAME
LOGFILE=$PRINTDIR/${SCANNAME}_log.txt
DICOMDIR=$NEWDIR/dicom

function find_largest {
    target_path=$1
    target_pattern=$2
    
    # Return a list of matches with sizes...
    find ${target_path}/${target_pattern} -type f -printf "%s\t%p\n" | \
        # ...then sort (largest will be the last entry now)...
        sort -n | \
        # ...then take only the last line (largest)...
        tail -1 | \
        # ...and finally, strip the size so only the path remains.
        sed "s~^.*${target_path}~${target_path}~"
}

if [ $# -ne 1 ]
then
  echo "ERROR: dicom2stl takes exactly 1 argument, the path to a .zip file of DICOM images."
else
    if [[ $BASENAME == *.zip ]]
    then
        (
        # Create, or clean, folder
        if [ ! -d $NEWDIR ]
        then
            mkdir -v -p $DICOMDIR
        else
            rm -v -rf $NEWDIR/*
            mkdir -v $DICOMDIR
        fi
        
        # Copy, unzip, and delete DICOM image archive
        cp -v $FILENAME $NEWDIR
        unzip $NEWDIR/$BASENAME -d $DICOMDIR
        rm -v $NEWDIR/$BASENAME
        
        # Convert the DICOM images to a .nii file
        dcm2niix $DICOMDIR
        
        # Find out the name of the largest .nii file
        TARGETNII=$(find_largest $DICOMDIR "*.nii")
        
        # Move the .nii to the correct place
        mkdir -v -p $NEWDIR/input
        mv -v $TARGETNII $NEWDIR/input/struct.nii
        
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
