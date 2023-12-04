#!/bin/bash

cwdFolder=$(pwd)
srcFolder="$(dirname "$cwdFolder")/src"
utilsFolder="$(dirname "$cwdFolder")/utils"

export utilsFolder


# Get the options
while getopts "i:o:h" option; do
   case $option in
      i) PathToRaw=$OPTARG;;
      o) PathToSave=$OPTARG;;
      h|-help)
      echo "options:"
      echo "-h                		show brief help"
      echo "-i=Input Folder Path        specify an input folder"
      echo "-o=Output Folder Path       specify a directory to store output"
      exit 0
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done


echo $PathToRaw
echo $PathToSave

export PathToRaw
export PathToSave

python ${srcFolder}/preprocessingroi_nrrd.py

