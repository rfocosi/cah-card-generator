#!/bin/bash
generatedFolder="generated"
mkdir -p "$generatedFolder"
outputFileName="CAH_cover"
lineSize=12
pointSize=28
page="White"
fill="black"
pageColor="#ffffff"
row=0
col=0
newPage=1
cardWidth=200
cardHeight=260

line1="Cards"
line2="Against"
line3="Humanity."

for i in {1..32}; do
  if [ "$col" == "4" ]; then
    row=$((row+1))
    col=0
  fi
  if [ "$row" == "4" ]; then
    page="Black"
    fill="white"
    pageColor="#231f20"
    row=0
    newPage=1
  fi
  outputFile="$generatedFolder/$outputFileName-$page.jpg"
  if [ "$newPage" == "1" ]; then
    convert -size 850x1100 xc:$pageColor "$outputFile"
    newPage=0
  fi

  posCol=$((cardWidth*col))
  posRow=$((cardHeight*row))

  convert -weight bold -pointsize $((pointSize)) -fill $fill \
    -draw "text $((posCol+42)),$((posRow+85)) '$line1' text $((posCol+42)),$((posRow+115)) '$line2' text $((posCol+42)),$((posRow+145)) '$line3'" "$outputFile" "$outputFile"

  echo "page $page:$i"
  col=$((col + 1))
done
