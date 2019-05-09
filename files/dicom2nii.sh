#!/bin/bash
dcm2niix scans/$1
mkdir -p scans/$1/input
mv scans/$1/*.nii scans/$1/input/struct.nii
rm scans/$1/*