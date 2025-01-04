function gencsvhdlsignals(fid, name, bits)
%gencsvhdlsignals(fid, name, bits)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

L = size(bits, 1);
W = size(bits, 2);

for l = 1:L
	for w = 1:W
		if bits(l, w) > 0
			fprintf(fid, 'signal %s_%d_%d : std_logic_vector(%d downto 0);\n', name, l, w, bits(l, w)-1);
		end
	end
end

