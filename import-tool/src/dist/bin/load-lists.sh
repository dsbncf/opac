#!/bin/bash


MAIN=bncf.opac.lists.OpacListLoader

OPTS="-p etc/opactools.properties"

LIB=./lib
classpath="etc:$LIB/*"

LISTS="autore_fc descrittore_fc titolo_fc soggetto_fc deweyall_fc"

for list in $LISTS
do
        echo "loading list for $list"
        java -classpath "$classpath" $MAIN $OPTS $* $list
done


