Running CAH Generator
=====================

First, be sure you already has installed Imagemagick and GhostScript:

sudo apt-get install imagemagick ghostscript

Card Files Format
=================

```
{text};{pick};{draw}
```
Ps.: The fields `{pick}` and `{draw}` works only with *black cards* and are optional

Examples:

- black_cards.csv
```
Lovin' you is easy 'cause you're ________________.
I went from ________ to ________________, all thanks to __________________.;3;2
For my next trick, I will pull __________ out of ____________.;2
```

- white_cards.csv
```
Being rich.
Friends with benefits.
Teaching a robot to love.
Me time.
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
