#!/bin/bash
if [ $# -ne 1 ]
then
  echo "ERROR: mri2stl takes exactly 1 argument, the name of the subdirectory in /3dprintscript/scans/."
else
    SCANNAME=$1
    PRINTDIR=/3dprintscript
    WORKDIR=$PRINTDIR/scans
    SCANDIR=$WORKDIR/$SCANNAME
    
    export FREESURFER_HOME=/usr/local/freesurfer
    source $FREESURFER_HOME/SetUpFreeSurfer.sh
    
    if [ -d "$SCANDIR" ];
    then
        $PRINTDIR/3Dprinting_brain.sh $WORKDIR $SCANNAME /usr/bin
    else
        echo "ERROR: Scan directory does not exist in /3dprintscript/scans/."
    fi
fi
