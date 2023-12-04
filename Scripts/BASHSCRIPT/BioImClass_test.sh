#!/bin/bash

cwdFolder=$(pwd)
srcFolder="$(dirname "$cwdFolder")/src"
utilsFolder="$(dirname "$cwdFolder")/utils"

export utilsFolder

while getopts "i:j:o:m:h" option; do
   case $option in
      i) NameInput=$OPTARG;;
      j) NameInputMask=$OPTARG;;
      o) NameOutput=$OPTARG;;
      m) NameModel=$OPTARG;;
      h|-help)
      echo "options:"
      echo "-h=how brief help"
      echo "-i=Input Folder Path to Preprocessing image specify an action to use"
      echo "-j=Input Folder Path to Preprocessing mask specify an action to use"
      echo "-o=Output Folder Path specify a directory to store output"
      echo "-m=Input Folder to model (.h5) specify location of the pretrain model"
      exit 0
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done



PathToModel=$NameModel
PathToDataIm=$NameInput
PathToDataMk=$NameInputMask
PathToSave=$NameOutput

echo $PathToModel
echo $PathToSave
echo $PathToDataIm
echo $PathToDataMk

NameToCombine=`basename "$PathToDataIm"`


IFS='_' read -r -a array <<< "$NameToCombine"

###NameToCombine=%NameToCombine:~0,% #${NameToCombine:5:}

NameToCombine=COMBINE
PathToData="$(dirname "$PathToDataIm")"/${NameToCombine}
echo TESTTEST
echo $PathToData


mkdir -p $PathToData;


cp -Rvf  $PathToDataIm/*.nrrd $PathToData
cp -Rvf  $PathToDataMk/*.nrrd $PathToData


export PathToModel
export PathToSave
export PathToData

python ${srcFolder}/test_ene.py

echo "$src"
