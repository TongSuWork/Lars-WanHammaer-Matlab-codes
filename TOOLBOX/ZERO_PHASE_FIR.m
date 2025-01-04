	function HR = ZERO_PHASE_FIR(h, wT, t) 	% 	Computes the zero-phase frequency response for a symmetric 	%	linear phase FIR filter at the frequencies wT. 	%	h - impulse response, t - type. 	%	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Linnea Rosenbaum, 2004-11-02	% 	Modified by: 	LW 2005-11-03	% 	Copyright:		by authors - not released for commercial use	% 	Version:		1	% 	Known bugs:	 	% 	Report bugs to:	Wanhammar@gmail.com		N = length(h)-1;	if t == 1		HR = h(N/2 + 1);		for m = 1:N/2			HR = HR + 2*h(N/2+1-m)*cos(wT'*m);		end	elseif t == 2		HR = 0;		for m =1:(N+1)/2			HR = HR + 2*h((N+1)/2 - m + 1)*cos(wT'*(m-1/2));		end	elseif t == 3		HR = 0;		for m =1:(N+1)/2			HR = HR + 2*h(N/2-m+1)*sin(wT'*(m-1/2));		end	elseif t == 4		HR = 0;		for m =1:(N+1)/2			HR = HR + 2*h((N+1)/2-m+1)*sin(wT'*(m-1/2));		end	end