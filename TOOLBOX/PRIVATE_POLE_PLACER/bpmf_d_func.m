	function [D] = bpmf_d_func(Z,NIN,NZ,q,z0_sqred)	%  	% Calculates the D value in the Z_frequency 	% point z0_sqred. The D function is used for finding 	% arc minimums for the bandpass maximally flat filter case. 	% Other input arguments are the number of attenuation 	% poles at infinity NIN, the number of attenuation poles 	% at the origin NZ, the passband quotient q = wb/wa and 	% the attenuation pole vector Z.		% Author: 			Per Loewenborg    % Modified by:		LW	% Copyright:		by authors - not released for commercial use	% Version: 			1		% Known bugs:		None	% Report bugs to:	larsw@isy.liu.se		m = NZ+NIN+2*length(Z);	A_sq = ((q^(2*NZ))*prod(Z.^4) )^(1/m);	D = (NZ/2)*( (A_sq + q^2)/(q^2 - z0_sqred) ) + ...	(NIN/2)*( (A_sq + 1)/(1-z0_sqred) ) + sum((A_sq+Z.^2)./(Z.^2-z0_sqred) );		