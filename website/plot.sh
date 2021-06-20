#!/bin/sh
while read NAME
do
	ONAME=$(echo "$NAME" | sed -e 's/.txt/.svg/g')
	cat "data/$NAME" | ./parce2plot | gnuplot -p -e 'set terminal svg font "serif,14"; set xlabel "Время, ЧЧ:ММ"; set ylabel "Температура, ˚C"; set autoscale y; set ytics 4; set mytics 4; set xdata time; set timefmt "%H:%M:%S"; set format x "%H:%M"; set xtics 3*3600; set mxtics 3; set style line 1 lc rgb "#FF0000" pt 7 ps 0.35 lt 1 lw 1; plot "-" using 1:2 notitle w p ls 1' > "plot/$ONAME"
done
