	function [L] = lp_loss_epb(Z, NIN, Z_vec) 	%	% Calculates the loss L(Z_vec) in Z-frequencies Z_vec given	% a attenuation pole vector Z for the LP case 	% with equiripple passband.	% Also the number of attenuation poles at infinity NIN is required.		% Author: 			Per Loewenborg    % Modified by:		LW	% Copyright:		by authors - not released for commercial use	% Version: 			1		% Known bugs:		None	% Report bugs to:	larsw@isy.liu.se 		L = ones(1,length(Z_vec));	N = length(Z);	for k = 1:N		L = L.*(Z_vec+Z(k));		L = L./(Z_vec-Z(k)); 	end	L = L.*( (Z_vec+1).^(NIN/2) );	L = L./( (Z_vec-1).^(NIN/2) );	