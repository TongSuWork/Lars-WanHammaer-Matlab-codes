function msd = genmsdcoeffs(val, w, signed)
%msd = genmsdcoeffs(val, w, signed)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

bin1s = sum(dectobin(val, w, signed));

ireps = genmsdcoeffs_int(val, bin1s);

sd1s = sum(abs(ireps), 2);

min1s = min(sd1s);

msd = ireps(sd1s == min1s, :);

if size(msd, 2) > w
	if sum(sum(msd(:, 1:end-w))) > 0
		error 'genreps: increase w'
	else
		msd = msd(:, end-w+1:end);
	end
elseif size(msd, 2) < w
	msd = [zeros(size(msd, 1), w-size(msd, 2)) msd];
end

