uses sysutils;
var
	filename, date, buf: string;
	fields: array[1..3] of string;
	fi, ti, fo: text;
	i : integer;

procedure parce(inp: string; var temp, date, time: string);
var
	i, j: integer;
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

begin
	while not eof do
	begin
		readln(filename);
		date := filename;
		delete(date, pos('.txt', date), length('.txt'));
		{end init}
		assign(fi, 'data/'+filename);
		assign(ti, 'datatemplate.html');
		assign(fo, 'datahtml/'+date+'.html');
		reset(fi);
		reset(ti);
		rewrite(fo);
		buf := '';
		while buf <> '<!--marker1-->' do
		begin
			readln(ti, buf);
			writeln(fo, StringReplace(buf, '$DATE', date, [rfReplaceAll]));
		end;
		while not eof(fi) do
		begin
			for i := 1 to 3 do
				fields[i] := '';
			readln(fi, buf);
			parce(buf, fields[1], fields[2], fields[3]);
			if fields[1] = 'CONLOST' then
				writeln(fo, '<tr bgcolor="red"> <th> ПОТЕРЯ СВЯЗИ', '</th> <th>', fields[3], '</th> <th>', fields[2], 'T', fields[3], '+07:00</th> </tr>')
			else writeln(fo, '<tr> <th>', fields[1], '</th> <th>', fields[3], '</th> <th>', fields[2], 'T', fields[3], '+07:00</th> </tr>');
		end;
		while not eof(ti) do
		begin
			readln(ti, buf);
			writeln(fo, StringReplace(buf, '$DATE', date, [rfReplaceAll]));
		end;
		{end.}
		close(fi);
		close(ti);
		close(fo);
	end;
end.
