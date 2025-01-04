	function [G, Z, P, dc, ds] = CONSTRAINED_LP_IIR(Nnum, Nden, Ts, Tp, wcT, wsT, Dratio) 		% 	Program for the design of constrained or unconstrained  	%	lowpass IIR filters using the Remez exchange algorithm.		% 	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Lars Wanhammar 	% 	Modified by: 	 		% 	Copyright:		by authors - not released for commercial use	% 	Version:		1	 	%	Known bugs:			% 	Report bugs to:	Wanhammar@gmail.com		%	Reference: Liang U.-K. and De Figueiredo R.J.P.: An Efficient Iterative 	%	Algorithm for Designing Optimal Recursive Digital Filters, IEEE Tans. 	%	on Acoustics, Speech, and Signal Procesing, Vol. ASSP-31, No. 5, pp.  	%	1110-1120, Oct. 1983. 		% (Remez uses the frequency range 0-0.5 instead of 0 - pi rad)	W00 = 1;	D00 = 1;	%	Weighting and desired value at F = 0	W05 = 1;		%	Weighting value at F = 0.5 	ITDmax = 5;		%	Maximum number of design cycles to design a filter 			IEPSDS = -1;	%	Criterion set to stop the design cycles 	IEPSIT = -1;	%	Criterion set to stop the iterations within each cycle	RMULT = 1;		% 	Choose the initial D05 as this multiple of D05min 	RN02 = 1;		%	Parameter to control the initial D05 when Nden is odd		Tpi = 2*pi;	Fp = wcT/Tpi; Fs = wsT/Tpi;		NoddTs = mod(length(Ts),2); NfnsTs = ceil(length(Ts)/2);	NoddTp = mod(length(Tp),2); NfnsTp = ceil(length(Tp)/2);	N1 = Nnum+1; N01 = mod(N1,2); NF1 = ceil(N1/2);	N2 = Nden+1; Nodd2 = mod(N2,2); N2 = 2*N2-1;	IEPSDS = -1; IEPSIT = -1; ITDmax = 5; ds = 0; 	D05 = 1000; RN02 = 1;  EPSDS = 10^(IEPSDS);  EPSIT = 10^(IEPSIT); 	ITDS = 1; 	 LGrid = 16;  NEG = 0;  ND05 = 1; 	goto = 1;	while goto < 100		switch goto 		case 1			if (Nodd2 == 1),  				goto = 2; 			else				N02 = mod(N2,2); NF2 = ceil(N2/2) + mod(N2,2);				Den2(NF2) = 1; Nstate = 1; goto = 6; 			end		case 2 				N02 = mod(N2,2);	NF2 = ceil(N2/2);			Den2 = zeros(1,N2);  Den2(NF2) = 1;	Nodd2 = 1;	Nstate = 1; goto = 6; 		case 3 	% Is the filter with the required ripple ratio found?			Ratio = ds/dc; 	DIFF = abs(Dratio-Ratio)/Dratio;			if (DIFF < EPSDS), goto = 16; else 				ITDS = ITDS+1; 				if (ITDS > ITDmax), 					disp(['Maximum number of design cycles exceeded']); 					goto = 16;				else 					% Calculate the new D05 value based on the 3/2 power relation.					D05 = ((Dratio/Ratio)^0.66667)*D05;					Nstate = 1; goto = 6;				end			end		case 6	 			if (Nstate == 2), 				goto = 9; 			else % ===== Design of the numerator N(z) starting here				Nfilt = N1;  Nodd = N01; Nfcns = NF1; DELF = 0.5/(LGrid*Nfcns); 				Grid(1) = 0; DES(1) = D00; WT(1) = W00;  				k = 2; 	Grid(k) = Fs;	goto = 8;			end		case 8 				DES(k) = 0;  F = Grid(k);  			WT(k) = 1/sqrt(HatF(F, Den2,N02,NF2));			k = k+1; Grid(k) = Grid(k-1) + DELF; 				if (Grid(k) < 0.5), 				goto = 8; 			else 				F = Grid(k);  DES(k) = 0; 				TsF = abs(HatF(F, Ts, NoddTs, NfnsTs));				TpF = HatF(F, Tp, NoddTp, NfnsTp);				WT(k) = TsF/sqrt(HatF(0.5,Den2,N02,NF2))/TpF;				Mgrid = k; goto = 13; 				% Do REMEZ algorithm to design the numerator N(z). 			end		case 9 % =====  Design the denominator Dt(z) starting here.			Nfilt = N2; if (Nodd2 == 0), Nfilt = N2+2; end 			Nodd = N02; Nfcns = NF2; 			DELF = 0.5/(LGrid*Nfcns); k = 1; Grid(1) = 0;  goto = 10;		case 10 			F = Grid(k);  			TpF = HatF(F, Tp, NoddTp, NfnsTp)^2; 			TsF = HatF(F, Ts, NoddTs, NfnsTs)^2;			DES(k) = HatF(F,Num,N01,NF1)^2;   			DES(k) = TsF*DES(k)/TpF;  WT(k) = 1/DES(k); k = k+1;				Grid(k) = Grid(k-1) + DELF;			if Grid(k) < Fp, 				goto = 10; 			else 				Grid(k) = Fp; F = Grid(k);  				TpF = HatF(Fp, Tp, NoddTp, NfnsTp)^2;				TsF = HatF(Fp, Ts, NoddTs, NfnsTs)^2; 				DES(k) = HatF(F,Num,N01,NF1)^2;  				DES(k) = TsF*DES(k)/TpF; WT(k) = 1/DES(k); 				if (ND05 == 1), goto = 12; else goto = 11; end 				end		case 11 	% Include the point F = 0.5 in the design procedure of Dt(z). 			k = k+1; Grid(k) = 0.5;	 DES(k) = D05; 	WT(k) = W05; goto = 12;			case 12  	% Set up a new approximation problem			Mgrid = k;	goto = 13;		case 13 			if (NEG == Nodd), 				if (Grid(Mgrid) > (0.5-DELF)), Mgrid = Mgrid-1; end 			end			if (Nodd ~= 1) 				for k = 1:Mgrid 					Change = cos(pi*Grid(k));	DES(k) = DES(k)/Change; 					WT(k) = WT(k)*Change; 				end 			end			% Initial guess for the extremal frequencies - equally spaced along the Grid.			TEMP = floor((Mgrid-1)/Nfcns);		 			for k = 1:Nfcns, Iext(k) = (k-1)*TEMP+1; end	 			Iext(Nfcns+1) = Mgrid; 	NM1 = Nfcns-1; 	NZ = Nfcns+1; 			% Remez =============				[Alpha, Err, Dev] = REMEZ_EX(Nfilt, NEG, Nfcns, Mgrid, Grid, Iext, DES, WT);			if (Nstate == 2) % Does the solution converge?				Den2 = Alpha; Dev = Dev/2;	Dds = abs(Dev-ds)/Dev; 				if (Dds > EPSIT)					ds = Dev; Nstate = 1;  goto = 6; 				else 					if (Dds < EPSIT & ND05 ~= 1), goto = 3; else  goto = 15; end 				end			else 				Num = Alpha;				dc = Dev; Num = Alpha;	Nstate = 2; goto = 6;			end		case 15 			D05min = HatF(0.5,Den2,N02,NF2); RATmin = ds/dc; 				if (Dratio < RATmin), 				D05min, RATmin				disp(['Dratio is less than RATmin. No solution exists.'])				goto = 200;  			else  				D05 = RMULT*D05min; ND05 = 2; 				if (Nodd2 == 0)					D05 = D05/RN02; goto = 2; 				else 					Nstate = 1; goto = 6; 				end 			end			case 16 % Output section			%	disp([' ***** Filter with the desired ripple ratio found ****']) 			%	disp(['The number of used design cycles = ']), ITDS 			%	D05 			ds;  % Passband ripple 			dc;  % Stopband ripple			%	disp(['The numerator polynomial N(z) = ']) ;			Num  = cat(2, Num, fliplr(Num(1:length(Num)-N01)));			%	disp(['The denumerator polynomial D(z) = ']) ;			Den2 = cat(2, Den2, fliplr(Den2(1:length(Den2)-Nodd2)));			goto = 200;		end		end		% Factorise Den2	P = roots(Den2); P(abs(P) >= 1) = [];	Den = ROOTS_2_POLY(P);	Z = roots(Num);	P = roots(Den);	G = 1/real(abs(PZ_2_FREQ_Z(1, Z, P, 0)));	% Addd poles at z = 0 if needed	Np = max(0, length(POLYMULT(Ts, Num))-length(POLYMULT(Tp, Den)));	P = cat(1, P, zeros(Np,1));	return		function HatF = HatF(F, Alpha, Nodd, Nfns) 		% 	Function HatF computes the magnitude of the transfer function H(z)	%	evaluated on the unit circle at point F.  Alpha is the first half 	%	of the impulse response.		% 	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Lars Wanhammar 2008-07-12	% 	Modified by: 	 		% 	Copyright:		by authors - not released for commercial use	% 	Version:		1	 	%	Known bugs:			% 	Report bugs to:	larsw@isy.liu.se		NM1 = Nfns-Nodd;	if NM1 == 0		HatF = Alpha(1);	else		HatF = 0; Tpi = 2*pi;		if (Nodd == 1)			for  k=1:NM1 				HatF = HatF + cos(Tpi*F*k)*Alpha(NM1+1-k);			end		else			for k = 1:NM1 				HatF = HatF + cos(Tpi*F*(k-0.5))*Alpha(NM1+1-k);			end		end		HatF = HatF*2; 		if (Nodd == 1), HatF = HatF+Alpha(Nfns); 	end	end	HatF = abs(HatF);		return	