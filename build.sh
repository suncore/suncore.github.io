#!/bin/sh

for i in *.md
do
   o=`basename -s .md $i`.html
   cat header.html > $o
   markdown $i >> $o
   cat footer.html >> $o
done
