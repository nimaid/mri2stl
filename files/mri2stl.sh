#!/bin/bash
STARTTIME=`date +%s`
function printtime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%d days ' $D
  (( $H > 0 )) && printf '%d hours ' $H
  (( $M > 0 )) && printf '%d minutes ' $M
  (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '
  printf '%d seconds' $S
}
function timer {
    printtime $((`date +%s`-STARTTIME))
}

if [ $# -ne 1 ]
then
  echo "MRI2STL ERROR: program takes exactly 1 argument, the name of the subdirectory in /3dprintscript/scans/."
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
        3Dprinting_brain $WORKDIR $SCANNAME /usr/bin
        
        # Alright, now let's check the results.
        BADOUT="MRI2STL ERROR: Program did not produce any usable output. Check the logs above for errors."
        
        # Is there even a final output?
        if [ ! -f "$OUTDIR/final.stl" ]
        then
            echo $BADOUT
            exit -1
        fi
        
        # Output created, is it garbage?
        FILESIZE=$(wc -c < $OUTDIR/final.stl)
        if [ $FILESIZE -lt 1024 ]
        then
            echo $BADOUT
            exit -1
        fi
        
        # Seemingly good raw output is there.
        # Let's double check that the cortical model is there, too.
        if [ ! -f "$OUTDIR/cortical.stl" ]
        then
            echo $BADOUT
            exit -1
        fi
        
        # Okay, so we have a valid cortical model at least.
        # Did the program capture the subcortical structures?
        if [ -f "$OUTDIR/subcortical.stl" ]
        then
            SUBCORT=1
        else
            SUBCORT=0
        fi
            
        # Got it. Now, do we have a smoothed output?
        if [ -f "$OUTDIR/final_s.stl" ]
        then
            # Is the smoothed output garbage?
            FILESIZE=$(wc -c < $OUTDIR/final_s.stl)
            if [ $FILESIZE -lt 1024 ]
            then
                SMOOTH=0
            else
                SMOOTH=1
            fi
        else
            SMOOTH=0
        fi

        # Now let's figure out path names and prints
        TOPATH=brain_${SCANNAME}
        if [ $SUBCORT -eq 1 ]
        then
            TOPATH=${TOPATH}_cort+subcort
        else
            TOPATH=${TOPATH}_cortical
        fi
        
        if [ $SMOOTH -eq 1 ]
        then
            FROMPATH=$OUTDIR/final_s.stl
            TOPATH=${TOPATH}_smoothed.stl
        else
            FROMPATH=$OUTDIR/final.stl
            TOPATH=${TOPATH}_raw.stl
        fi
        
        # Perform the copy
        cp $FROMPATH $PRINTDIR/$TOPATH
        
        # Print what happened.
        printf "\n\n\n"
        echo "~~~~~~~~~~~~~~~~ MRI2STL RESULTS ~~~~~~~~~~~~~~~~"
        
        if [ $SUBCORT -eq 1 ]
        then
            echo "Both the cortical and subcortical structures"
            echo "were successfully captured."
        else
            echo "The cortical structure was successfully"
            echo "captured, but the subcortical structure"
            echo "could not be captured."
        fi
        
        printf "\n"
        if [ $SMOOTH -eq 1 ]
        then
            echo "The final output was able to be smoothed."
        else
            echo "The final output could not be smoothed."
            echo "You may wish to run laplacian smoothing"
            echo "manually to get a cleaner look."
        fi
        
        printf "\n"
        printf "Conversion took %s.\n" "$(timer)"
        printf "The final output was saved to \"%s\"\n" $TOPATH
        
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    else
        echo "ERROR: Scan directory does not exist in /3dprintscript/scans/."
    fi
fi
