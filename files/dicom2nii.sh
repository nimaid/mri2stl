#!/bin/bash
PRINTDIR=/3dprintscript
dcm2niix $PRINTDIR/scans/$1
mkdir -p $PRINTDIR/scans/$1/input
mv $PRINTDIR/scans/$1/*.nii $PRINTDIR/scans/$1/input/struct.nii
rm $PRINTDIR/scans/$1/*