#! /bin/sh

OUTDIR=../texinfo

for md in *.md; do
    newName=$(echo $md | sed 's/\.md//')
    echo "Converting" $newName
    pandoc --from=markdown $md --to=texinfo -s -o $OUTDIR/$newName.texi
done
