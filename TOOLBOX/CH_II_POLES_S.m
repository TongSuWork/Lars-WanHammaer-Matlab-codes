	function [G, Z, R_ZEROS, P, Wsnew] = CH_II_POLES_S(Wc, Ws, Amax, Amin, N)		% 	Computes the denormalized poles, zeros and gain constant for  	%	an analog lowpass Chebyshev II filter with |H(0)| = 1.	%	The design margin is used to decrease the stopband edge.		% 	Toolbox for DIGITAL FILTERS USING MATLAB 		% 	Author: 		Lars Wanhammar 1983-08-15	%	Modified by: 	LW,  1987-01-19, 2002-07-28, 2004-09-22,2013-12-29	%					LW 2014-04-13	% 	Copyright:		by authors - not released for commercial use	% 	Version:		1	% 	Known bugs:			% 	Report bugs to:	Wanhammar@gmail.com		if floor(N) ~= -floor(-N)		disp('N must be an interger')		return	end	if ~(abs(N-round(N)) < eps)		N = floor(CH_ORDER_S(Wc, Ws, Amax, Amin)) + 1;		return	end	if (Wc >= Ws)		error('Not a lowpass filter. Must have Wc < Ws')  	elseif ( Amax <= 0 | Amax >= Amin)		error('The passband attenuation must be 0 < Amax < Amin')	elseif ( Amin <= 0)		error('The stopband attenuation must be Amin > Amax > 0')	end 	M = (N + rem(N, 2))/2; 	Apn = Amax*log(10)/20;	epsilon = sqrt(2*exp(Apn)*sinh(Apn));	Q = asinh(epsilon*cosh(N*acosh(Ws/Wc)))/N;	Z = [];		P = [];	% The reflection zeros are	R_ZEROS = zeros(N, 1);	% Compute the poles	for k = 1:M		v = (2*k-1)*pi/(2*N);			R = Ws/sqrt(cos(v)^2+sinh(Q)^2);		if (2*k-1 == N)			P = [-R; P];		else			wi = i*(atan(-coth(Q)*cot(v))+pi);			R0 = R*exp(wi);			P = [conj(R0); R0; P];		end		if ~(rem(N, 2) == 1 & k == M)	% Compute the zeros			Z0 = i*Ws/cos(v);			Z = [conj(Z0); Z0; Z];		end	end		G = real(prod(-P)/prod(-Z));	% Gain constant			X = acosh(sqrt((10^(0.1*Amin)-1)/(10^(0.1*Amax)-1)))/N;	Wsnew = Wc*cosh(X);	