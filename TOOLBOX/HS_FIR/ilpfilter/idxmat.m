function mat = idxmat(rows, cols, im)
%mat = idxmat(rows, cols, im)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

mat = zeros(rows, cols);

for i = 1:size(im, 1)
	mat(im(i, 1)+1, im(i, 2)) = im(i, 3);
end

