function h = sincfilter(dec, casc, skew)
%h = sincfilter(dec, casc, skew)
%
%Creates the impulse response of a cascaded moving average filter.
%Inputs:
%  dec - number of ones in the moving average filter
%  casc - number of moving average filters in cascade
%  skew - number of leading zeroes in the impulse response
%Outputs:
%  h - the impulse response

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

if nargin < 3
	skew = 0;
end

g = ones(1, dec);
h = 1;
for c = 1:casc
	h = conv(h, g);
end

h = [zeros(1, skew) h];

