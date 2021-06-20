uses sysutils;


procedure parce(inp: string; var temp, date, time: string);
var
	sbuf, sbuf1: string;
begin
	sbuf := inp;
	delete(sbuf, pos(';', sbuf), length(sbuf) - pos(';', sbuf) + 1);
	temp := sbuf;
	sbuf1 := inp;
	delete(sbuf1, 1, length(temp) + 1);
	sbuf := sbuf1;
	delete(sbuf, pos('T', sbuf), length(sbuf) - pos('T', sbuf) + 1);
	date := sbuf;
	sbuf := sbuf1;
	delete(sbuf, 1, length(date) + 1);
	delete(sbuf, pos('+', sbuf), length(sbuf) - pos('+', sbuf) + 1);
	time := sbuf;
end;

var
	s, temp, date, time: string;
begin
	while not eof do
	begin
		readln(s);
		parce(s, temp, date, time);
		if temp <> 'CONLOST' then
			writeln(time, ' ', StringReplace(temp, ',', '.', [rfReplaceAll]));
	end;
end.
