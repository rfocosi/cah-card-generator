Running CAH Generator
=====================

First, be sure you already has installed Imagemagick and GhostScript:

sudo apt-get install imagemagick ghostscript

Card Files Format
=================

```
{text};{pick};{draw}
```
Ps.: The fields `{pick}` and `{draw}` are optional

Examples:
```
I went from _________ to _________________, all thanks to ____________________.;3;2
Lovin' you is easy 'cause you're ______________.
```

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
