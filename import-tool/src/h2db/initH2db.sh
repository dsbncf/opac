#!/bin/bash

INIT_LIST="init-db.txt"

H2_MAIN=org.h2.tools.RunScript

dir=$(dirname "$0")
classpath="$dir/h2-1.4.193.jar:$dir/lucene-core-3.6.2.jar:$H2DRIVERS:$CLASSPATH"

[ $# -lt 1 ] && { echo; java -cp "$classpath" $H2_MAIN -?; exit 1; }

ask_confirm=1
if [ "$1" = "-y" ]; then
	ask_confirm=0
	shift;
fi

DB=${1};
shift;
[[ "$DB" != ./* ]] && [[ "$DB" != /* ]] && DB=./$DB

if [ $ask_confirm -gt 0 -a -f "$DB.mv.db" ]
then
	echo "database already exists: $B"
	echo -n "remove it (y/no) ? "
	read answ
	[ "$answ" = "y" ] && rm -f "$DB.mv.db"
fi

unset SCRIPTS
if [ $# -gt 0 ]
then
	SCRIPTS="$@"
else
	[ -f "$INIT_LIST" ] && SCRIPTS=$(cat "$INIT_LIST")
fi
[ -z "$SCRIPTS" ] && { echo "no scripts to execeute"; exit 3; }


opts="-url jdbc:h2:file:$DB -user sa"

for script in $SCRIPTS
do
	echo "$script ..."
	[ -n "$script" ] && java -cp "$classpath"  $H2_MAIN $opts -script $script
done
