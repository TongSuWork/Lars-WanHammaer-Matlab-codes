	function h = FLAT_LP_FIR_2(N, L, dsl, dsu)		% A program for the design of symmetric lowpass FIR 	% filters with flat monotonically decreasing passbands and 	% equiripple stopbands.		% output	%  h  : filter	% input	%  N  :  filter order (even)	%  L  : degree of flatness at wT = 0	% dsu and dsl: upper and lower stopband deviation, respectively. 	% Normally, we select dsu = -dsl		% Author: Ivan W. Selesnick, Rice University	%	%  Modifiesd	LW 2002-02-04		% Reference:	% "Exchange Algorithms for the Design of Linear Phase FIR Filters 	% and Differentiators Having Flat Monotonic Passbands and Equiripple 	% Stopbands" by I. W. Selesnick and C. S. Burrus, 	% IEEE Trans. on Cicuits and Systems II, 43(9):671-675, Sept 1996		%  calls subprograms: REFINE.m, LOCAL_MAX.m		N = N+1; % filter length	if dsl >= 0		disp('dsl must be be negative')		return	end	if (rem(N,2) == 0) | (rem(L,2) == 1)		disp('N and L must be be even')		return	else		g = 2^ceil(log2(10*N));               	% number of grid points		SN = 1e-10;                             % SN : SMALL NUMBER		q  = (N-L+1)/2;                         % number of filter parameters		Y  = [dsl*(1-(-1).^(1:q))/2 + dsu*((-1).^(1:q)+1)/2]';		w  = [0:g]'*pi/g;		wo = pi*(L/2)/(L/2+q);		wo = wo - (dsu-dsl);		n  = 0:q-1;		rs = n'*(pi-wo)/(q-1) + wo;		Z  = zeros(2*(g-q)+1,1);		A1  = sin(w/2).^L * (-1)^(L/2);		A1r = sin(rs/2).^L * (-1)^(L/2);						it = 0;		while 1 & (it < 10)				a2 = cos(rs*n)\[(Y-1)./A1r];			A2 = real(fft([a2(1);			a2(2:q)/2;Z;			a2(q:-1:2)/2])); 			A2 = A2(1:g+1);			A  = 1 + A1.*A2; 			ri = sort([LOCAL_MAX(A); LOCAL_MAX(-A)]);			ri(1:length(ri)-q) = [];			rs = (ri-1)*pi/g;			rs = REFINE(a2,L/2,rs);			A1r = sin(rs/2).^L * (-1)^(L/2);			Ar = 1 + (cos(rs*n)*a2).* A1r;			Err = max([max(Ar)-dsu, dsl-min(Ar)]);			fprintf(1,'    Err = %18.15f\n',Err);			%	if Err < SN, fprintf(1,'\n  Converged \n'), break, end			it = it + 1;		end		h = [a2(q:-1:2)/2; a2(1); a2(2:q)/2];	% H2		for k = 1:L/2			h = conv(h,[1 -2 1]')/4;	% add H1		end		h((N+1)/2) = h((N+1)/2) + 1;	end