	function A = lp_sb_atten_mf(Z,NIN,Z_vec,Amax)	% 	% Calculates the stopband attenuation  given a loss 	% scalar/vector for a maximally flat passband with Amax	% attenuation.		% Author: 			Per Loewenborg    % Modified by:		LW 	% Copyright:		by authors - not released for commercial use	% Version: 			1		% Known bugs:		None	% Report bugs to:	larsw@isy.liu.se		ep_sqred = (10^(0.1*Amax)) - 1;	A = prod(Z.^4);	A = A*ep_sqred;	B = (-1)^NIN;	B = B*( (Z_vec.^2-1).^NIN );		for k = 1:length(Z)			B = B.*( (Z_vec.^2-Z(k)^2).^2);   		end	A = 10*log10(1+A./B);