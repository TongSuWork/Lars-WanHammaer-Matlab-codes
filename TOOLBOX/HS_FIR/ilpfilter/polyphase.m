function hpoly = polyphase(h, ppfactor)
%hpoly = polyphase(h, ppfactor)
%
%Creates a polyphase decomposition of an impulse response.
%Inputs:
%  h - FIR impulse response
%  ppfactor - number of polyphase branches
%Outputs:
%  hpoly - matrix with rows corresponding to polyphase branches

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

n = mod(length(h), ppfactor);

if n > 0
	h = [h zeros(1, ppfactor-n)];
end

hpoly = reshape(h, ppfactor, length(h)/ppfactor);

