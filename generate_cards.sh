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
  text=$(echo $line | cut -d\; -f1)
  pick=$(echo $line | cut -d\; -f2 -s)
  draw=$(echo $line | cut -d\; -f3 -s)

  if [ "$col" == "4" ]; then
    row=$((row+1))
    col=0
  fi
  if [ "$row" == "5" ]; then
    page=$((page + 1))
    row=0
    newPage=1
  fi

  outputFile="$generatedFolder/$outputFileName-$page.jpg"
  if [ "$newPage" == "1" ]; then
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
    textRows[l]=${text:${lp}:lineSize}
    if [ "${#textRows[l]}" -eq "$lineSize" ]; then
      textRows[l]=`echo ${textRows[l]} | perl -pe 's/\s[^\s]+$//g'`
      lp=$((1+$lp+${#textRows[l]}))
      more=1
    fi
    l=$((l+1))
  done

  currentCol=$((posCol+42))
  currentRow=$((posRow+85))
  for textRow in "${textRows[@]}"; do
    convert -weight bold -pointsize $((pointSize)) -fill $fontColor \
      -draw "text $currentCol,$currentRow '$textRow'" "$outputFile" "$outputFile"
    currentRow=$((currentRow+rowSize))
  done

  bottomText="Cards Against Humanity"
  bottomRow=$((posRow+165-row))
  if [ "$pick" != "" ]; then
    bottomText="CAH"
    convert -fill white -draw "circle $((currentCol+158)),$((bottomRow+60)) $((currentCol+153)),$((bottomRow+50))" \
      -weight bold -pointSize 15 -fill white -draw "text $((currentCol+105)),$((bottomRow+66)) 'PICK'" \
      -weight bold -pointSize 18 -fill black -draw "text $((currentCol+154)),$((bottomRow+66)) '$pick'" \
      "$outputFile" "$outputFile"
  fi
  if [ "$draw" != "" ]; then
    bottomText="CAH"
    convert -fill white -draw "circle $((currentCol+158)),$((bottomRow+30)) $((currentCol+153)),$((bottomRow+20))" \
    -weight bold -pointSize 15 -fill white -draw "text $((currentCol+95)),$((bottomRow+36)) 'DRAW'" \
    -weight bold -pointSize 18 -fill black -draw "text $((currentCol+154)),$((bottomRow+36)) '$draw'" \
    "$outputFile" "$outputFile"
  fi

  convert -weight normal -pointSize 10 -fill $fontColor -draw "text $((currentCol+33)),$((bottomRow+64)) '$bottomText'" "$outputFile" "$outputFile"

  echo "page $page:$text"
  col=$((col + 1))
done < "$inputFile"
