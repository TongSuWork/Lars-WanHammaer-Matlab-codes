function N = numreps(r, type)
%N = numreps(r, type)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

if type == 'bin'
	N = 1;
elseif type == 'msd'
	N = 1;
	for n = 1:length(r.msd)
		N = N * size(r.msd{n}, 1);
	end
else
	error "numreps: invalid type"
end

