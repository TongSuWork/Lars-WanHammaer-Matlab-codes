	function t = trig(w,M,f)	 	% 	Used in solving linear programming filter design.		%	Toolbox for DIGITAL FILTERS USING MATLAB	%	%	Author: 		Hakan Johansson	% 	Modified by: 	 	% 	Copyright:		by authors - not released for commercial use	% 	Version: 		1	% 	Known bugs:	 	% 	Report bugs to:	Wanhammar@gmail.com		t(1:length(w),1) = 1;	n = 1:M;	for k=1:length(w)		if f == 1			t(k,2:M+1) = 2*cos(n*w(k));		elseif f == 0			t(k,1:M) = 2*cos((n-1/2)*w(k));		elseif f == 3			t(k,2:M+1) = sin((n+1)*w(k));		else %f=4			t(k,2:M+1) = sin((n+1/2)*w(k));		end	end