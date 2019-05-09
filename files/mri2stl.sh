#!/bin/bash
export FREESURFER_HOME=/usr/local/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

PRINTDIR=/3dprintscript
$PRINTDIR/3Dprinting_brain.sh $PRINTDIR/scans $1 /usr/bin