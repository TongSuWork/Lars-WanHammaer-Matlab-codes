	function [Gd, Zd, Pd] = PZ_BILINEAR_PZ_Z(G, Z, P, T) 	% 	Computes the poles and zeros for a digital filter from the poles and zeros 	% 	of an analog filter using the bilinear transformation	%	%      H(z) = H(s) |	%                  | s = (2/T)*(z-1)/(z+1) 	%	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Lars Wanhammar, 2005-11-04	% 	Modified by: 	LW 2009-07-15	% 	Copyright:		by authors - not released for commercial use	% 	Version: 		1		% 	Known bugs:			% 	Report bugs to:	Wanhammar@gmail.com	k = T/2;	Pd = (1 + k*P)./(1 - k*P); 					% Bilinear transformation	Zd = (1 + k*Z)./(1 - k*Z);	Zd = [Zd; -ones(length(Pd)-length(Zd), 1)];	 % Add extra zeros at -1	gainA = abs(real(G*prod(Z)/prod(P)));	Gd = gainA/real(prod(1-Zd)/prod(1-Pd)); 