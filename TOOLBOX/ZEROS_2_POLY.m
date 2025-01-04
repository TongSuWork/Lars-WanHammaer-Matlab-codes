	function POLY = ZEROS_2_POLY(Z) 	%	Converts zeros of a polynomial to a polynomial. 	% 	Toolbox for DIGITAL FILTERS USING MATLAB 		%	Author: 		Lars Wanhammar, 2011-02-5	%	Modified by:		%	Copyright:		by authors - not released for commercial use	%	Version:		1	 	%	Known bugs:	 	%	Report bugs to:	Wanhammar@gmail.com	POLY = 1;	for n = 1:length(Z)		POLY = POLYMULT(POLY, [1 -Z(n)]);	end	POLY = real(POLY);