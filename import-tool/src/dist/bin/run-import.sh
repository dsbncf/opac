#!/bin/bash

MAIN=bncf.opac.tools.Dispatcher

LIB=./lib

classpath="etc:$LIB/*"

java -classpath "$classpath" $MAIN

