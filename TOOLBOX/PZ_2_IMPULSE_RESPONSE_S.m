	function [h, h0, t_axis] = PZ_2_IMPULSE_RESPONSE_S(G, Z, P, t_axis)		%	Computes the impulse response of a causal analog filter 	%	over the time interval given by t_axis from the poles and zeros.	%	The lower limit of t_axis is zero.  	%	h0 is the value of the impulse response at t = 0.		%	Toolbox for DIGITL FILTERS USING MATLAB 		% 	Author: 		Lars Wanhammar 2006-02-27	% 	Modified by: 	LW 2010-04-16, 2010-08-07, 2017-11-07	% 	Copyright:		by authors - not released for commercial use	% 	Version:		1	% 	Known bugs:			% 	Report bugs to:	Wanhammar@gmail.com 	if length(Z) == length(P)		% Deg(Num) = Deg(Denum)		Num = G*ROOTS_2_POLY(Z);		Den = ROOTS_2_POLY(P);		[dirac0, Remaind] = LONG_DIV(Num, Den);		Num2 = roots(Remaind);		[Residues, P, Mult] = PART_FRACT_EXPANSION(Remaind(1), Num2, P); 	else 					% Deg(Num) < Deg(Denum)		dirac0 = 0;		[Residues, P, Mult] = PART_FRACT_EXPANSION(G, Z, P);	end	h = zeros(1,length(t_axis));	for k = 1:length(Residues)		m = max(0, Mult(k)-1);		h = h + (Residues(k)/prod(1:m))*t_axis.^m.*exp(P(k).*t_axis);		end	h0 = h(1)+dirac0;	h = real(h);