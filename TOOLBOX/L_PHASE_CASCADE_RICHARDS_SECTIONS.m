	function alfa = L_PHASE_CASCADE_RICHARDS_SECTIONS(P)		% 	Computes the adaptor (symmetric) coefficients in a lattice wave 	%	digital filter with lattice branches consisting of 	%	cascaded Richards' sections of first- and second-order.	%	%	H = (-a1z^2 + (a1-1)a2z + 1)/(z^2 + (a1-1)a2z - a1)		%	Toolbox for DIGITAL FILTERS USING MATLAB		% Author: 			Lars Wanhammar 2009-11-15	% Modified by: 	 	LW 2011-04-24	% Copyright:		by authors - not released for commercial use	% Version:			1 	% Known bugs:			% Report bugs to:	Wanhammar@gmail.com		P = flipud(P)	alfa(1) = P(1);	for k = 2:2:length(P)-1		alfa(k) = -abs(P(k))^2;		alfa(k+1) = real(2*P(k))/(1-alfa(k));	end