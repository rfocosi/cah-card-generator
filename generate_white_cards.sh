#!/bin/bash
generatedFolder="generated/white"
mkdir -p "$generatedFolder"
outputFileName="CAH_page"
page=1
row=0
col=0
newPage=1
while read -r line
do
    line=`echo ${line} | perl -pe "s/'//g"`

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
       sourceFile="CAH_BlankWhiteCards.jpg"
       newPage=0
    fi

    posRow=$((200*row))
    posCol=$((200*col))

    lineSize=22
    pointSize=15

    line1=${line:0:lineSize}
    if [ ! "${#line1}" -lt "$lineSize" ]
    then  
       line1=`echo ${line1} | perl -pe 's/\s[^\s]+$//g'`
    fi

    line2=${line:$((${#line1}+1)):lineSize}
    if [ ! "${#line2}" -lt "$lineSize" ]
    then
       line2=`echo ${line2} | perl -pe 's/\s[^\s]+$//g'`
    fi

    line3=${line:$((${#line1} + ${#line2} + 2)):lineSize}
    if [ ! "${#line3}" -lt "$lineSize" ]
    then
       line3=`echo ${line3} | perl -pe 's/\s[^\s]+$//g'`
    fi

    line4=${line:$((${#line1} + ${#line2} + ${#line3} + 3)):lineSize}
    if [ ! "${#line4}" -lt "$lineSize" ]
    then
       line4=`echo ${line4} | perl -pe 's/\s[^\s]+$//g'`
    fi

    line5=${line:$((${#line1} + ${#line2} + ${#line3} + ${#line4} + 4)):lineSize}
    if [ ! "${#line5}" -lt "$lineSize" ]
    then
       line5=`echo ${line5} | perl -pe 's/\s[^\s]+$//g'`
    fi

    convert -weight bold -pointsize $((pointSize)) -fill black -draw "text $((posCol+42)),$((posRow+85)) '$line1' text $((posCol+42)),$((posRow+115)) '$line2' text $((posCol+42)),$((posRow+145)) '$line3' text $((posCol+42)),$((posRow+175)) '$line4' text $((posCol+42)),$((posRow+205)) '$line5'" "$sourceFile" "$outputFile"
    echo "page $page:$line"
    col=$((col + 1))
done < "$1"
