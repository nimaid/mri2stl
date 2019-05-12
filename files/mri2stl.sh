#!/bin/bash
if [ $# -ne 1 ]
then
  echo "ERROR: mri2stl takes exactly 1 argument, the name of the subdirectory in /3dprintscript/scans/."
else
    SCANNAME=$1
    PRINTDIR=/3dprintscript
    WORKDIR=$PRINTDIR/scans
    SCANDIR=$WORKDIR/$SCANNAME
    OUTDIR=$SCANDIR/output
    
    export FREESURFER_HOME=/usr/local/freesurfer
    source $FREESURFER_HOME/SetUpFreeSurfer.sh
    
    if [ -d "$SCANDIR" ];
    then
        # Run the conversion
        $PRINTDIR/3Dprinting_brain.sh $WORKDIR $SCANNAME /usr/bin
        
        # Copy the final output to the main directory
        if [ -f "$OUTDIR/final_s.stl" ]
        then
            cp $SCANDIR/output/final_s.stl $PRINTDIR/brain_${SCANNAME}.stl
            echo "Coppied final smoothed .stl to main directory!"
        elif [ -f "$OUTDIR/final.stl" ]
        then
            cp $SCANDIR/output/final.stl $PRINTDIR/brain_${SCANNAME}_raw.stl
            echo "Smoothed output not found."
            echo "Coppied the unsmoothed final .stl to main directory, run laplacian smoothing manually."
        else
            echo "ERROR: Program did not produce any usable output. Check for errors above."
        fi
    else
        echo "ERROR: Scan directory does not exist in /3dprintscript/scans/."
    fi
fi
