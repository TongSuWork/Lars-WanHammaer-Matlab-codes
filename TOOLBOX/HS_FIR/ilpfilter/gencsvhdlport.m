function gencsvhdlport(fid, in, out)
%gencsvhdlport(fid, in, out)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

M = size(in, 1);
Wi = size(in, 2);
Wo = size(out, 2);

fprintf(fid, 'port (\n');
fprintf(fid, '  clk, reset : in std_logic;\n');

comma = '';

for l = 1:M
	for w = 1:Wi
		if in(l, w) > 0
			fprintf(fid, '%s  in_%d_%d : in std_logic_vector(%d downto 0)', comma, l, w, in(l, w)-1);
			comma = sprintf(';\n');
		end
	end
end

for w = 1:Wo
	if out(w) > 0
		fprintf(fid, '%s  out_%d : out std_logic_vector(%d downto 0)', comma, w, out(w)-1);
		comma = sprintf(';\n');
	end
end

fprintf(fid, ');\n');

