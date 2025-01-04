	function hBP = LP_2_BP_FIR(hLP)		% 	Generate the impulse response of a symmetric bandpass filter 	%	from a lowpass FIR filter by replacfing z �> (-1)^(m/2)*z^2			% 	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		LW 2007-12-06	% 	Modified by: 			% 	Copyright:		by authors - not released for commercial use	% 	Version:		1	 	% 	Known bugs:			% 	Report bugs to:	Wanhammar@gmail.com		N = length(hLP) -1;	if mod(N,2) == 1		disp(['Error � must be an even order FIR filter'])		break	end	k = length(hLP);	hBP = zeros(1,2*k)	for m = 1:k-1		hBP((m-1)*2+1) = (-1)^m/2*hLP(m);	end 