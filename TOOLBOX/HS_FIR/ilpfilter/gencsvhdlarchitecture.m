function gencsvhdlarchitecture(fid, name, csspec, csmap)
%gencsvhdlarchitecture(fid, name, csspec, csmap)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

fprintf(fid, 'architecture generated of %s is\n', name);

fprintf(fid, 'component fa\n');
fprintf(fid, 'port (in1, in2, in3 : in  std_logic;\n');
fprintf(fid, '      outs, outc    : out std_logic);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, 'component ha\n');
fprintf(fid, 'port (in1, in2   : in  std_logic;\n');
fprintf(fid, '      outs, outc : out std_logic);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, 'component fa_noc\n');
fprintf(fid, 'port (in1, in2, in3 : in  std_logic;\n');
fprintf(fid, '      outs          : out std_logic);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, 'component ha_noc\n');
fprintf(fid, 'port (in1, in2 : in  std_logic;\n');
fprintf(fid, '      outs     : out std_logic);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, 'component dff\n');
fprintf(fid, 'port (clk, reset : in std_logic;\n');
fprintf(fid, '      d : in  std_logic;\n');
fprintf(fid, '      q : out std_logic);\n');
fprintf(fid, 'end component;\n');

% Generate the signals
cellin = csspec.bits;
cellout = csspec.bits(2:end, :)-[csspec.ppin(2:end, :); zeros(1, csmap.W)];
gencsvhdlsignals(fid, 'cellin', cellin);
gencsvhdlsignals(fid, 'cellout', cellout);

fprintf(fid, 'begin\n');

% Generate map of module input to cells
for i = 1:size(csmap.pp, 1)
	l = csmap.pp(i, :);
	fprintf(fid, 'cellin_%d_%d(%d) <= in_%d_%d(%d);\n', l(1), l(2), l(4), l(1), l(2), l(3));
end

% Generate map of constant vector inputs
for i = 1:size(csmap.cin, 1)
	l = csmap.cin(i, :);
	fprintf(fid, 'cellin_%d_%d(%d) <= ''1'';\n', l(1), l(2), l(3));
end

% Generate FA mapping of cells
for n = 1:size(csmap.fa, 1)
	line = csmap.fa(n, :);
	level = line(1);
	bit = line(2);
	in1 = line(3);
	in2 = line(4);
	in3 = line(5);
	outs = line(6);
	outc = line(7);
	if outc == -1
		fprintf(fid, ...
		'add_%d_%d_%d_%d_%d: fa_noc port map(cellin_%d_%d(%d), cellin_%d_%d(%d), cellin_%d_%d(%d), cellout_%d_%d(%d));\n', ...
		level, bit, in1, in2, in3, ...
		level, bit, in1, level, bit, in2, level, bit, in3, ...
		level, bit, outs);
	else
		fprintf(fid, ...
		'add_%d_%d_%d_%d_%d: fa port map(cellin_%d_%d(%d), cellin_%d_%d(%d), cellin_%d_%d(%d), cellout_%d_%d(%d), cellout_%d_%d(%d));\n', ...
		level, bit, in1, in2, in3, ...
		level, bit, in1, level, bit, in2, level, bit, in3, ...
		level, bit, outs, level, bit-1, outc);
	end
end

% Generate HA mapping of cells
for n = 1:size(csmap.ha, 1)
	line = csmap.ha(n, :);
	level = line(1);
	bit = line(2);
	in1 = line(3);
	in2 = line(4);
	outs = line(5);
	outc = line(6);
	if outc == -1
		fprintf(fid, ...
		'add_%d_%d_%d_%d: ha_noc port map(cellin_%d_%d(%d), cellin_%d_%d(%d), cellout_%d_%d(%d));\n', ...
		level, bit, in1, in2, level, bit, in1, level, bit, in2, ...
		level, bit, outs);
	else
		fprintf(fid, ...
		'add_%d_%d_%d_%d: ha port map(cellin_%d_%d(%d), cellin_%d_%d(%d), cellout_%d_%d(%d), cellout_%d_%d(%d));\n', ...
		level, bit, in1, in2, level, bit, in1, level, bit, in2, ...
		level, bit, outs, level, bit-1, outc);
	end
end

% Generate feed-through connections of cells
for n = 1:size(csmap.feed, 1)
	line = csmap.feed(n, :);
	level = line(1);
	bit = line(2);
	in = line(3);
	out = line(4);
	fprintf(fid, 'cellout_%d_%d(%d) <= cellin_%d_%d(%d);\n', ...
		level, bit, out, level, bit, in);
end

% Generate cell interconnections with registers
for n = 1:size(csmap.reg, 1)
	line = csmap.reg(n, :);
	level = line(1);
	bit = line(2);
	in = line(3);
	out = line(4);
	fprintf(fid, 'reg_%d_%d_%d: dff port map(clk, reset, cellout_%d_%d(%d), cellin_%d_%d(%d));\n', ...
		level, bit, in, level, bit, in, level+1, bit, out);
end

% Generate cell interconnections without registers
for n = 1:size(csmap.conn, 1)
	line = csmap.conn(n, :);
	level = line(1);
	bit = line(2);
	in = line(3);
	out = line(4);
	fprintf(fid, 'cellin_%d_%d(%d) <= cellout_%d_%d(%d);\n', ...
		level+1, bit, out, level, bit, in);
end

% Generate connections to module output
for w = 1:csmap.W
	if csspec.bout(w) > 0
		fprintf(fid, 'out_%d <= cellin_%d_%d;\n', w, csmap.L, w);
	end
end

fprintf(fid, 'end generated;\n');

