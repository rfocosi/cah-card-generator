#!/bin/bash
generatedFolder="generated"
mkdir -p "$generatedFolder"
outputFileName="CAH_cover"
page="White"
fill="black"
rectFill="#ffffff"
row=0
col=0
newPage=1
for i in {1..40}
do
    if [ "$col" == "4" ]
    then
       row=$((row+1))
       col=0
    fi
    if [ "$row" == "5" ]
    then
       page="Black"
       fill="white"
       rectFill="#231f20"
       row=0
       newPage=1
    fi
    outputFile="$generatedFolder/$outputFileName-$page.jpg"
    sourceFile="$outputFile"
    if [ "$newPage" == "1" ]
    then
       sourceFile="img/CAH_Blank""$page""Cards.jpg"
       newPage=0
    fi

    posRow=$((200*row))
    posCol=$((200*col))

    lineSize=12
    pointSize=28

    line1="Cards"
    line2="Against"
    line3="Humanity."

    convert -weight bold -pointsize $((pointSize)) -fill $fill -draw "text $((posCol+42)),$((posRow+85)) '$line1' text $((posCol+42)),$((posRow+115)) '$line2' text $((posCol+42)),$((posRow+145)) '$line3' fill $rectFill rectangle $((posCol+38)),$((posRow-row+215)) $((posCol+182)),$((posRow-row+245))" "$sourceFile" "$outputFile"

    echo "page $page:$i"
    col=$((col + 1))
done
