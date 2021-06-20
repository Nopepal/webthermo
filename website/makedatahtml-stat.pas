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

function get_dd(inp: string): longint;
var
	temp, date, time: string;
	o: longint;
	code:byte;
begin
	o:=0;
	parce(inp, temp, date, time);
	delete(temp, pos(',', temp), 1);
	val(temp, o, code);
	get_dd := o;
end;

function timetos(time: string): longint;
var
	sh, sm, ss: string;
	h, m, s, o: longint;
	code: byte;
begin {00:00:00}
	sh := time[1] + time[2];
	sm := time[4] + time[5];
	ss := time[7] + time[8];
	val(sh, h, code);
	val(sm, m, code);
	val(ss, s, code);
	o := h*3600 + m*60 + s;
	timetos := o;
end;

procedure stat(filename: string; var smin, smax, smean: string; var sonline: string);
var
	{statistics variables}
	time_s: array [1..2] of longint;
	temp_dd: array [1..2] of longint;
	area: longint;
	fi: text;
	sBuf, temp, date, time: string;
	exFlag: boolean;
	fMean: real;
	min, max: longint;
	fMin, fMax: real;
	online : longint;
begin
	assign(fi, filename);
	reset(fi);
	area := 0;
	online := 0;
	exFlag := true;
	while not eof(fi) do
	begin
		readln(fi, sBuf);
		parce(sBuf, temp, date, time);
		time_s[1] := timetos(time);
		temp_dd[1] := get_dd(temp);
		{min max}
		if exFlag then
		begin
			exFlag := false;
			min := temp_dd[1];
			max := temp_dd[1];
		end;
		{min max end}
		while (not eof(fi)) and (temp <> 'CONLOST') do
		begin
			readln(fi, sBuf);
			parce(sBuf, temp, date, time);
			time_s[2] := timetos(time);

			area += (time_s[2] - time_s[1])*temp_dd[1];
			online += time_s[2] - time_s[1];

			if temp <> 'CONLOST' then
			begin
				temp_dd[2] := get_dd(temp);
				temp_dd[1] := temp_dd[2];
				time_s[1] := time_s[2];
				{min max}
				if temp_dd[1] > max then max := temp_dd[1];
				if temp_dd[1] < min then min := temp_dd[1];
				{min max end}
			end;
		end;
	end;
	close(fi);
	if temp <> 'CONLOST' then
	begin
		area += (24*3600 - time_s[1])*temp_dd[1];
		online += 24*3600 - time_s[1];
	end;
	fMean := area / online / 10;
	str(fMean:0:1, smean);
	smean[pos('.', smean)] := ',';
	fMin:= min / 10;
	fMax:= max / 10;
	str(fMin:0:1, smin);
	str(fMax:0:1, smax);
	smax[pos('.', smax)] := ',';
	smin[pos('.', smin)] := ',';
	str(online div 3600 mod 24, sBuf);
	sonline := format('%.2d:%.2d:%.2d', [online div 3600 mod 24,
	online div 60 mod 60, online mod 60]);
end;

var
	filename, date, buf: string;
	fields: array[1..3] of string;
	fi, ti, fo: text;
	i : integer;
	{stat variables}
	min, max, mean: string;
	online: string;
begin
	while not eof do
	begin
		readln(filename);
		//writeln(filename);
		date := filename;
		delete(date, pos('.txt', date), length('.txt'));
		filename:='data/'+filename;
		{end init}
		stat(filename, min, max, mean, online);
		assign(fi, filename);
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
			buf := StringReplace(buf, '$DATE', date, [rfReplaceAll]);
			buf := StringReplace(buf, '$MIN', min, [rfReplaceAll]);
			buf := StringReplace(buf, '$MAX', max, [rfReplaceAll]);
			buf :=  StringReplace(buf, '$MEAN', mean, [rfReplaceAll]);
			buf :=  StringReplace(buf, '$ONLINE', online, [rfReplaceAll]);
			writeln(fo, buf);
		end;
		{end.}
		close(fi);
		close(ti);
		close(fo);
	end;
end.
