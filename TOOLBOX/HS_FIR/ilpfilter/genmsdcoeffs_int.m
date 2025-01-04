function msd = genmsdcoeffs_int(val, level)
%msd = genmsdcoeffs_int(val, level)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

if val == 0
	msd = 0;
	return
end

if level == 0
	msd = [];
	return
end

scale = 0;
while mod(val, 2) == 0
	val = val/2;
	scale = scale+1;
end

msd1 = genmsdcoeffs_int(val-1, level-1);
msd2 = genmsdcoeffs_int(val+1, level-1);

if size(msd1, 1) > 0
	msd1(:, end) = 1;
end

if size(msd2, 1) > 0
	msd2(:, end) = -1;
end

msd = zeros(size(msd1, 1)+size(msd2, 1), max(size(msd1, 2), size(msd2, 2))+scale);
msd(1:size(msd1, 1), end-size(msd1, 2)+1-scale:end-scale) = msd1;
msd(size(msd1, 1)+1:end, end-size(msd2, 2)+1-scale:end-scale) = msd2;

