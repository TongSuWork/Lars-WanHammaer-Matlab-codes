function creps = gencoeffreps(h, wc, signed)
%creps = gencoeffreps(h, wc, signed)
%
%Generates different representations for the impulse response of an FIR
%filter. Currently implemented representations are binary and minimum
%signed digit.
%Inputs:
%  h - the impulse response
%  wc - the coefficient wordlength to use
%  signed - signedness of coefficients
%Outputs:
%  creps - structure containing the coefficient representations, to be
%          used in calls to chooserep.

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

N = length(h);

creps.h = h;
creps.wc = wc;

creps.bin = cell(1, N);
for n = 1:N
	creps.bin{n} = dectobin(h(n), wc, signed);
end

creps.msd = cell(1, N);
for n = 1:N
	creps.msd{n} = genmsdcoeffs(h(n), wc, signed);
end

