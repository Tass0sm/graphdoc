#! /bin/sh

OUTDIR=../info

for texi in *.texi; do
    newName=$(echo $texi | sed 's/\.texi//')
    echo "Converting" $newName

    pandoc --from=markdown $md --to=texinfo -s -o $OUTDIR/$newName.texi
done
