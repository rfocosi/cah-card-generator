#!/bin/bash
cardType=$1
inputFile=$2

if [ "$inputFile" == "" ]; then
  cardType=""
fi

if [ "$cardType" == "black" ]; then
  fontColor="white"
  cardColor=#231f20
elif [ "$cardType" == "white" ]; then
  fontColor="black"
  cardColor=#ffffff
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
cardWidth=200
cardHeight=260

while read -r line
do
  text=$(echo $line | sed -E s/\'/\\\\\'/g | cut -d\; -f1)
  pick=$(echo $line | cut -d\; -f2 -s)
  draw=$(echo $line | cut -d\; -f3 -s)

  if [ "$col" == "4" ]; then
    row=$((row+1))
    col=0
  fi
  if [ "$row" == "4" ]; then
    page=$((page + 1))
    row=0
    newPage=1
  fi

  outputFile="$generatedFolder/$outputFileName-$page.jpg"
  if [ "$newPage" == "1" ]; then
    convert -size 850x1100 xc:$cardColor "$outputFile"
    newPage=0
  fi

  posCol=$((cardWidth*col))
  posRow=$((cardHeight*row+lineSize))

  convert -stroke $fontColor -draw "fill $cardColor rectangle $((posCol+lineSize)),$((posRow)) $((posCol+lineSize+cardWidth)),$((posRow+cardHeight))" "$outputFile" "$outputFile"

  l=0
  lp=0
  more=1
  textRows=()
  while [ $more -eq 1 ]; do
    more=0
    textRows[l]=${text:${lp}:lineSize}
    if [ "${#textRows[l]}" -eq "$lineSize" ]; then
      textRows[l]=`echo ${textRows[l]} | sed -E 's/ [^ ]+$//'`
      lp=$((1+$lp+${#textRows[l]}))
      more=1
    fi
    l=$((l+1))
  done

  currentCol=$((posCol+(rowSize*2)))
  currentRow=$((posRow+(rowSize*2)))
  for textRow in "${textRows[@]}"; do
    convert -weight bold -pointsize $((pointSize)) -fill $fontColor \
      -draw "text $currentCol,$currentRow '$textRow'" "$outputFile" "$outputFile"
    currentRow=$((currentRow+rowSize))
  done

  bottomText="Cards Against Humanity"
  bottomRow=$((posRow+(lineSize*8)-row))
  if [ "$cardType" == "black" ]; then
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
  fi

  convert -draw "image over $((posCol+42)),$((bottomRow+(lineSize*2))),0,0 'img/CAH_ico.png'" \
    -weight normal -pointSize 10 -fill $fontColor -draw "text $((currentCol+33)),$((bottomRow+(rowSize*3))) '$bottomText'" "$outputFile" "$outputFile"

  echo "page $page:$text"
  col=$((col + 1))
done < "$inputFile"
