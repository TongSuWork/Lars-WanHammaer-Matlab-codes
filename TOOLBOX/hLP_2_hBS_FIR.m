	function hBS = hLP_2_hBS_FIR(hLP)		% 	Transform the impulse response, hLP(n) of a lowpass FIR filter 	%	to the impulse response, hBS(n) of a symmetric bandstop FIR filter.		% 	Toolbox for DIGITAL FILTERS USING MATLAB'
 	% Author: 			Lars Wanhammar 2004-09-23	% Modified by:	% Copyright:		by authors - not released for commercial use	% Version: 			1 	% Known bugs:			% Report bugs to:	Wanhammar@gmail.com		hBS = ZEMBEDD(hLP, 2);	