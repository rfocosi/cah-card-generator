#!/bin/bash
cardType=$1
inputFile=$2

if [ "$inputFile" == "" ]; then
  cardType=""
fi

if [ "$cardType" == "black" ]; then
  sourceImage="img/CAH_BlankBlackCards.jpg"
  fontColor="white"
elif [ "$cardType" == "white" ]; then
  sourceImage="img/CAH_BlankWhiteCards.jpg"
  fontColor="black"
else
  echo "Usage:"
  echo "generate_cards.sh {black|white} {csv-file}"
  exit -1
fi

generatedFolder="generated/$cardType"
mkdir -p "$generatedFolder"
outputFileName="CAH_page"
page=1
row=0
col=0
newPage=1
lineSize=22
pointSize=15
rowSize=20

while read -r line
do
    pick=`echo ${line} | perl -pe "s/.+;//g"`
    line=`echo ${line} | perl -pe "s/;.*//g"`

    if [ "$col" == "4" ]
    then
       row=$((row+1))
       col=0
    fi
    if [ "$row" == "5" ]
    then
       page=$((page + 1))
       row=0
       newPage=1
    fi

    outputFile="$generatedFolder/$outputFileName-$page.jpg"
    if [ "$newPage" == "1" ]
    then
      cp $sourceImage $outputFile
      newPage=0
    fi

    posRow=$((200*row))
    posCol=$((200*col))

    l=0
    lp=0
    more=1
    textRows=()
    while [ $more -eq 1 ]; do
      more=0
      textRows[l]=${line:${lp}:lineSize}
      if [ "${#textRows[l]}" -eq "$lineSize" ]
      then
         textRows[l]=`echo ${textRows[l]} | perl -pe 's/\s[^\s]+$//g'`
         lp=$((1+$lp+${#textRows[l]}))
         more=1
      fi
      l=$((l+1))
    done

    currentLine=$((posRow+85))
    for textRow in "${textRows[@]}"; do
      convert -weight bold -pointsize $((pointSize)) -fill $fontColor -draw "text $((posCol+42)),$((currentLine)) '$textRow'" "$outputFile" "$outputFile"
      currentLine=$((currentLine+rowSize))
    done

    if [ "$pick" == "2" ]
    then
       convert -draw "image over $((posCol+42)),$((posRow-row+215)),0,0 'img/CAH_black_pick2.jpg'" "$outputFile" "$outputFile"
    fi
    echo "page $page:$line"
    col=$((col + 1))
done < "$inputFile"
