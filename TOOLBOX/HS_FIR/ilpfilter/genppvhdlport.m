function genppvhdlport(fid, innum, inwidth, out)
%genppvhdlport(fid, innum, inwidth, out)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

fprintf(fid, 'port (\n');
fprintf(fid, 'clk, reset : in std_logic;\n');

comma = '';

for n = 0:innum-1
	fprintf(fid, '%s  in_%d : in std_logic_vector(%d downto 0)', comma, n, inwidth-1);
	comma = sprintf(';\n');
end

for l = 1:size(out, 1)
	for w = 1:size(out, 2)
		if out(l, w) > 0
			fprintf(fid, '%s  out_%d_%d : out std_logic_vector(%d downto 0)', comma, l, w, out(l,w)-1);
			comma = sprintf(';\n');
		end
	end
end

fprintf(fid, ');\n');

