Running CAH Generator
=====================

First, be sure you already has installed Imagemagick package:

sudo apt-get install imagemagick

Also, the scripts requires GhostScript and Perl.

Usage
=====

```
./generate_cards.sh {black|white} {csv-file}
```

Examples:
```
./generate_cards.sh black black_cards.csv
./generate_cards.sh white white_cards.csv
./generate_covers.sh
```

The scripts will read the files, and create a new folder "generated" with black and white cards.
