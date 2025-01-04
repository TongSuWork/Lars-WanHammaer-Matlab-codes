	function [p,K] = lp_get_poles(P,Q,wb,Amax,wi)	%  	% Finds the poles p of the analog filter and the 	% scaling constant k given the P and Q vectors	% resulting from bairstows factorization,	% the passband cutoff frequency wb and the 	% passband attenuation Amax.	% Also the attenuation pole angular frequencies wi are needed.	% Author: 			Per Loewenborg    % Modified by:		LW 	% Copyright:		by authors - not released for commercial use	% Version: 			1		% Known bugs:		None	% Report bugs to:	larsw@isy.liu.se		fb = wb/(2*pi);	LP = length(P);	LQ = length(Q);	a = 0;	b = 0;	ZF = 0;	ZQ = 0;	p = [];	T = 1;	for k = 1:LP		if P(k) == inf			a0 = abs(Q(k));			sigma0 = sqrt(wb^2/(a0-1));			p = [p -sigma0];			T = T*(sigma0^2 + wb^2);		else			a(k) = sqrt( wb^4/ (1+P(k)+Q(k)) );			b(k) = ( (1+P(k)/2)*(wb^2) )/(1+P(k)+Q(k));			ZF(k) = ( fb^4/(1+P(k)+Q(k)) )^0.25;			ZQ(k) = 1/((2*(1-(b(k)/a(k))))^0.5);    			p = [p roots([1 2*pi*ZF(k)/ZQ(k) (2*pi*ZF(k))^2 ])']; 			T = T*( (wb^2-(2*pi*ZF(k))^2)^2 +(wb*2*pi*ZF(k)/ZQ(k))^2);		end	end	N = prod( (wb^2-wi.^2).^2 );	K = Amax-10*log10(T/N);	K = 10^(-0.05*K);