function genstrucvhdl(filename, name, ppspec, csspec, vmaspec)
%genstrucvhdl(filename, name, ppspec, csspec, vmaspec)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

L = size(ppspec.inbits, 1);
W = size(ppspec.inbits, 2);

fid = fopen(filename, 'w+');

genvhdllibs(fid);

% Generate entity
fprintf(fid, 'entity %s is\n', name);
fprintf(fid, 'port (\n');
fprintf(fid, '  clk, reset : in std_logic');

for phase = 0:ppspec.numphases-1
	fprintf(fid, ';\n  x_%d : in std_logic_vector(%d downto 0)', phase, ppspec.wdata-1);
end

fprintf(fid, ';\n  y : out std_logic_vector(%d downto 0)', size(vmaspec.bout, 2)-1);

fprintf(fid, ');\n');
fprintf(fid, 'end %s;\n', name);

% Generate architecture
fprintf(fid, 'architecture generated of %s is\n', name);

% Partial product generation component
fprintf(fid, 'component %s_pp\n', name);
genppvhdlport(fid, ppspec.numphases, ppspec.wdata, ppspec.inbits);
fprintf(fid, 'end component;\n');

% cstree component
fprintf(fid, 'component %s_cs\n', name);
gencsvhdlport(fid, csspec.ppin, csspec.bout);
fprintf(fid, 'end component;\n');

% rcvma component
fprintf(fid, 'component %s_vma\n', name);
gencsvhdlport(fid, vmaspec.ppin, vmaspec.bout);
fprintf(fid, 'end component;\n');

% Internal signals after partial product generation
for l = 1:size(ppspec.inbits, 1)
	for w = 1:size(ppspec.inbits, 2)
		if ppspec.inbits(l, w) > 0
			fprintf(fid, 'signal pp_%d_%d : std_logic_vector(%d downto 0);\n', ...
				l, w, ppspec.inbits(l, w)-1);
		end
	end
end

% Internal signals after carry-save tree
for w = 1:size(csspec.bout, 2)
	if csspec.bout(w) > 0
		fprintf(fid, 'signal cs_%d : std_logic_vector(%d downto 0);\n', ...
			w, csspec.bout(w)-1);
	end
end

fprintf(fid, 'begin\n');

% Partial product generation instance
fprintf(fid, 'pp_i: %s_pp port map(\n', name);
fprintf(fid, '  clk => clk,\n');
fprintf(fid, '  reset => reset');

for phase = 0:ppspec.numphases-1
	fprintf(fid, ',\n  in_%d => x_%d', phase, phase);
end

for l = 1:size(ppspec.inbits, 1)
	for w = 1:size(ppspec.inbits, 2)
		if ppspec.inbits(l, w) > 0
			fprintf(fid, ',\n  out_%d_%d => pp_%d_%d', l, w, l, w);
		end
	end
end
fprintf(fid, ');\n');

% Carry-save reduction tree instance
fprintf(fid, 'cs_i: %s_cs port map(\n', name);
fprintf(fid, '  clk => clk,\n');
fprintf(fid, '  reset => reset');

for l = 1:size(ppspec.inbits, 1)
	for w = 1:size(ppspec.inbits, 2)
		if ppspec.inbits(l, w) > 0
			fprintf(fid, ',\n  in_%d_%d => pp_%d_%d', l, w, l, w);
		end
	end
end

for w = 1:size(csspec.bout, 2)
	if csspec.bout(w) > 0
		fprintf(fid, ',\n  out_%d => cs_%d', w, w);
	end
end
fprintf(fid, ');\n');

% VMA instance
fprintf(fid, 'vma_i: %s_vma port map(\n', name);
fprintf(fid, '  clk => clk,\n');
fprintf(fid, '  reset => reset');

for w = 1:size(csspec.bout, 2)
	if csspec.bout(w) > 0
		fprintf(fid, ',\n  in_1_%d => cs_%d', w, w);
	end
end

for w = 1:size(vmaspec.bout, 2)
	if vmaspec.bout(w) > 0
		fprintf(fid, ',\n  out_%d(0) => y(%d)', w, size(vmaspec.bout, 2)-w);
	end
end
fprintf(fid, ');\n');

% Assign unassigned outputs, if there are any
for w = 1:size(vmaspec.bout, 2)
	if vmaspec.bout(w) == 0
		fprintf(fid, '  y(%d) <= ''0'';\n', size(vmaspec.bout, 2)-w);
	end
end

fprintf(fid, 'end generated;\n');

fclose(fid);

