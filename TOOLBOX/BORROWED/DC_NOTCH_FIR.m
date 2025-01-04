 	function h = DC_NOTCH_FIR(wcT, Amax)		% 	Computes the impulse response of an equiripple DC-notch FIR filter		%	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Authors:		Zahradnik P. and Vlcek M. Note on the design of  	%					an equiripple DC-notch FIR filter, IEEE Trans.  	%					on Circuits	and Systmes, Part II, Vol. 54, No. 2,	%					pp 196-199, Feb. 2007.	% 	Modified by: 	Lars Wanhammar 2010-10-07	% 	Copyright:		by authors - not released for commercial use	% 	Version:			 	% 	Known bugs:		 	% 	Report bugs to:	Wanhammar@gmail.com	%	% Example:  wcT= 0.05*pi;	% Passband edge	%			Amax = 0.01; 	% Passband attenuation	% yields	Required filter order, Type I: N = 52	%			Actual Amax = 0.0097688  [dB]		s = sin(wcT/2)^2; 	t = 10^(-0.05*Amax);	La = 1/(1-s); 	nreal = (acosh((1+t)/(1-t)))/acosh((1+s)/(1-s));	n = ceil(nreal) ;	disp(['Required filter order, Type I: N = ', num2str(n)])	aact = 20*log10(1-2/(1+cosh(n*acosh(2*La-1))));	disp(['Actual Amax = ', num2str(-aact), '  [dB]'])	A = zeros(1,n+4); A(n+1) = La^n;	for k = 1:n		d1 = k*(2*n-k);		d2 = 2*((k-1)*(2*n+1-k)-(1-La)/La*(n+1-k)*(2*n+1-2*k));		d3 = 4*(1-La)/La*(n+2-k);		d4 = (-1)*2*((k-3)*(2*n+3-k)-(1-La)/La*(n+3-k)*(2*n+7-2*k));		d5 = (k-4)*(2*n+4-k);		A(n+1-k) = (A(n+2-k)*d2+A(n+3-k)*d3+A(n+4-k)*d4+A(n+5-k)*d5)/d1;	end	A(1) = A(1)/2;	a = [A(1) A(2:n+1)/2];	aflip = fliplr(a);	h = [aflip(1,1:max(size(a))-1) a];	norm = sum(h);	n1 = max(size(h));	n2 = floor(n1/2);	h = [h(1,1:n2) h(1,n2+1)+1 h(1,n2+2:n1)];	h = h/(norm+1);	h = [-h(1,1:n2) 1-h(1, n2-1) -h(1, n2+2:n1)];	%	figure(1)	%	PLOT_IMPULSE_RESPONSE_Z(h)	%	figure(2)	%	wT = linspace(0, pi, 10000);	%	H = freqz(h,1,wT);	%	PLOT_MAGNITUDE_Z_dB(wT, H, pi, 300, 'H')	