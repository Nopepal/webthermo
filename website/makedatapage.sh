#!/bin/sh
while read NAME
do
	echo "$NAME" | ./makedatahtml-stat
	echo "$NAME" | sh plot.sh
done

