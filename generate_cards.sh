#!/bin/bash
cardType=$1
inputFile=$2

if [ "$inputFile" == "" ]; then
  cardType=""
fi

if [ "$cardType" == "black" ]; then
  sourceImage="CAH_BlankBlackCards.jpg"
  fontColor="white"
elif [ "$cardType" == "white" ]; then
  sourceImage="CAH_BlankWhiteCards.jpg"
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
    sourceFile="$outputFile"
    if [ "$newPage" == "1" ]
    then
       sourceFile="$sourceImage"
       newPage=0
    fi

    posRow=$((200*row))
    posCol=$((200*col))

    line1=${line:0:lineSize}
    echo "0"
    if [ "${#line1}" -eq "$lineSize" ]
    then
       line1=`echo ${line1} | perl -pe 's/\s[^\s]+$//g'`
       echo $line1
    fi
    line2=${line:$((${#line1}+1)):lineSize}
    echo $((${#line1}+1))
    if [ "${#line2}" -eq "$lineSize" ]
    then
       line2=`echo ${line2} | perl -pe 's/\s[^\s]+$//g'`
       echo $line2
    fi
    line3=${line:$((${#line1} + ${#line2} + 2)):lineSize}
    echo $((${#line1} + ${#line2} + 2))
    if [ "${#line3}" -eq "$lineSize" ]
    then
       line3=`echo ${line3} | perl -pe 's/\s[^\s]+$//g'`
       echo $line3
    fi

    line4=${line:$((${#line1} + ${#line2} + ${#line3} + 3)):lineSize}
    echo $((${#line1} + ${#line2} + ${#line3} + 3))
    if [ "${#line4}" -eq "$lineSize" ]
    then
       line4=`echo ${line4} | perl -pe 's/\s[^\s]+$//g'`
       echo $line4
    fi

    line5=${line:$((${#line1} + ${#line2} + ${#line3} + ${#line4} + 4)):lineSize}
    echo $((${#line1} + ${#line2} + ${#line3} + ${#line4} + 4))
    echo $line5
    if [ "${#line5}" -eq "$lineSize" ]
    then
       line5=`echo ${line5} | perl -pe 's/\s[^\s]+$//g'`
    fi

    #convert -weight bold -pointsize $((pointSize)) -fill $fontColor -draw "text $((posCol+42)),$((posRow+85)) '$line1' text $((posCol+42)),$((posRow+115)) '$line2' text $((posCol+42)),$((posRow+145)) '$line3' text $((posCol+42)),$((posRow+175)) '$line4' text $((posCol+42)),$((posRow+205)) '$line5'" "$sourceFile" "$outputFile"
    if [ "$pick" == "2" ]
    then
       convert -draw "image over $((posCol+42)),$((posRow-row+215)),0,0 'CAH_black_pick2.jpg'" "$outputFile" "$outputFile"
    fi
    #echo "page $page:$line"
    col=$((col + 1))
done < "$inputFile"
