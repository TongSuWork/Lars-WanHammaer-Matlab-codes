	function [dev2] = forcehelp(nrip,des,wt,w,dev1,ksign,ino)	% Calculates the parameters of an allpass filter of order nall at	% nall angular frequencies w(i) such that it achieves the values	% des(i)-ksign*(-1)^i*dev1/wt(i) for i = 1,2,...,nall+1	% For this purpose, the procedure described in [1] is exploited.	% The information of the allpass filter is carried by beta(j) for	% j = 1,2,...,nall and ome = tan(x(j)) where j contains all the indexes 	% of i except for i = ino.	% This routine is used in connection with the remezall2 routine making	% the phase of an allpass filter equiripple.	% References:	% [1] T. Henk,  The generalization of arbitrary-phase polynomials...�, 	% Int. J. Circuit Theory and Appl., vol. 9, pp. 461-478, Sept. 1981.		% <---------------------------------------------------------------<< DH <<<	% SYM_WDF.m -> linremez.m -> newgrid.m	%                          -> iextnew.m	%                          -> forcing.m -> forcehelp.m -> phas.m	%                          -> phas.m	%                          -> removeiext.m	%            -> factors.m	% <---------------------------------------------------------------<< DH <<<	% INPUT	% nrip    number of ripples (nall+1)	% des     desired phase values at frequencies w(i)	% wt      weight function at frequencies w(i)	% w       nall distict angular frequencies	% dev1    specified phase deviation at nrip-1 frequencies of w(i), i~ = ino	% ksign   sign of first ripple +1/-1	% ino     extreme point where error is different than other extreme points	% OUTPUT	% BETA    beta(1) beta(2) ... beta(nall)	% OME     omega(1) omega(2) ... omega(nall)	% dev2    resulting phase deviation at w(ino)		% 	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Tapio Saramaki, 2018-03-10	% 	Modified by: 	LW, 2019-03-04	% 	Version: 		1	% 	Known bugs:			% 	Report bugs to:	tapio.saramaki@tut.fi		% <--- edited Jan-29-2007 with MATLAB R2006a ---------------------<< DH <<<		global OME OMEXOME BETA	nall = nrip-1;	%ino	%inoo = ino	ino(ino < 0 | ino>nrip) = nrip;  % extra extreme point (the one with largest 	% error) is last extremal point if 	j = 0;lsign = ksign;             % not given as initial value	for i = 1:nrip		if (i ~= ino)			j = j+1;                               % at each iteration round k, we			OME(j) = tan(w(i)/2);OMEXOME(j) = OME(j)^2; % select a fixed error e(k)			help = des(i)+lsign*dev1/wt(i);        % and then phase response of			phatan(j) = tan(help/2);               % A_N(k)(z) is forced to be		else                                       % D(w1(k))+(-1)^1*e(k)/W(w1(k))			lsign1 = lsign;                        % D(w2(k))+(-1)^2*e(k)/W(w2(k))		end                                     % ...		lsign = -lsign;                           % D(wr(k))+(-1)^r*e(k)/W(wr(k))	end                                           % for r = 1,2,...,N extreme points	% - Parameters characterizing the allpass filter -- DH -- - -- DH -- -  	BETA(1) = phatan(1)/OME(1);	for i = 2:nall		help = BETA(1)*OME(i)/phatan(i);		for j = 1:i-2			if (help == 1)				help = BETA(j+1)*(OMEXOME(i)-OMEXOME(j))/(1.0000000001-help);			else              %1.0000000001-help added to prevent divided by zero				help = BETA(j+1)*(OMEXOME(i)-OMEXOME(j))/(1-help);			end		end		BETA(i) = (1-help)/(OMEXOME(i)-OMEXOME(i-1));	end	% <--- Compute deviation at the last frequency point w(ino) ------<< DH <<<	help = phas(w(ino),des(ino))-des(ino);	dev2 = lsign1*wt(ino)*help;