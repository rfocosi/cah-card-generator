Running CAH Generator
=====================

First, be sure you already has installed Imagemagick package:

sudo apt-get install imagemagick

./generate_black_cards.sh black_cards.txt
./generate_white_cards.sh white_cards.txt
./generate_covers.sh

The scripts will read the files, and create a new folder "generated" with black and white cards.

Also, the scripts requires GhostScript and Perl.

