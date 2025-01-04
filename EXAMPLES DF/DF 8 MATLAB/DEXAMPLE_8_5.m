	clear all	close all	% EXAMPLE 8.5 HIHGPASS			Wc = 16000;	Ws = 9000;	r = 0.50;	Amax = -10*log10(1-r^2);	Amin = 40;	Rs = 50;	RL = 50;	v = Wc^2;	WIsquared = Wc^2; Omegac = Wc;	Omegas = WIsquared/Ws;	Ladder = 1; 				% 1 for a T ladder and 0 for a � ladder	N = CH_ORDER_S(Omegac, Omegas, Amax, Amin)	N = 5;					% Must be an integer. We select a 5th-order filter	[L, C, K] = CH_I_LADDER(Omegac, Omegas, Amax, Amin, N, Rs, RL, Ladder)	[L, C, K] = LP_2_HP_LADDER(L, C, K, WIsquared);	Z0 = []; T = 1;				% Used only for transmission lines	omega = [eps:6:30000];	H = LADDER_2_H(N, Z0, L, C, Rs, RL, K, omega, T);	subplot('position', [0.08 0.4 0.90 0.5]);	Att = MAG_2_ATT(H*2);		% Normalize the passband to 0 dB	PLOT_ATT_S(omega, Att);	PLOT_HP_SPEC_S(Wc, Ws, Amax, Amin); % Amin = 0 => No stopband spec	axis([0, 30000, 0, 60]);	L = L'	C = C'	zoom on