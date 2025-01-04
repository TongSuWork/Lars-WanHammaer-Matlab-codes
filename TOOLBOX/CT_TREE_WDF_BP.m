	function alfa = CT_TREE_WDF_BP(P)		% 	Computes the adaptor coefficients in an even order bandpass	%	circulator-tree wave digital filter consisting of 	%	four-port adaptors from the poles in the corresponding 	%	digital bandpass filter. 		%	Toolbox for DIGITAL FILTERS USING MATLAB		% Author: 			Lars Wanhammar 2008-01-15	% Modified by: 	 		% Copyright:		by authors - not released for commercial use	% Version:			1 	% Known bugs:			% Report bugs to:	Wanhammar@gmail.com		P = flipud(cplxpair(P))';	N = length(P)/2;	for k = 1:N	% Compute the adaptor coefficients		alfa(k,1) = (1 - abs(P(2*k))^2)/2;			% alfa1 = alfa2		alfa(k,2) = 1 - alfa(k,1) - real(P(2*k));	% alfa3		alfa(k,3) = 2 - 2*alfa(k,1) - alfa(k,2); 	% alfa4 	end	