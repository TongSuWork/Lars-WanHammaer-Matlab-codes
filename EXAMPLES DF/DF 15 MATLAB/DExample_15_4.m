	clear all	close all	clc	% Kernel filter	M = 5;	wTK = [0.05,0.1]*pi; dc = 0.01; ds = 0.001;	[N0, Be, D, W] = HERRMANN_LP_FIR_ORDER(wTK, [dc ds]);	N0		[NK, Be, D, W] = HERRMANN_LP_FIR_ORDER(M*wTK, [dc/3 ds]);		NK = NK+2	hK = REMEZ_FIR(NK,Be,D,W,'m');	wT = linspace(0,pi,1000);	HK = freqz(hK,1, M*wT);	subplot(2,1,1), PLOT_MAG_Z_dB(wT, HK, pi, 90, '-'), hold on		BeD = [0,0.05,0.30,0.5,0.7,0.9]*pi;	DD = [1 1 0 0 0 0]; 	WD = [dc ds ds]/ds;	ND = 14;		[hD, err] = REMEZ_FIR(ND, BeD, DD, WD,'m')		HD = freqz(hD,1,wT);	HI = HD;	PLOT_MAG_Z_dB(wT, HD, pi, 90, 'H')	H = HI.*HK.*HD;		subplot(2,1,2),	PLOT_MAG_Z_dB(wT, H, pi, 90, 'H')	zoom on	 	P = reshape(hD, M, length(hD)/M)	% Polyphase components	Amax = max(H_2_MAG(H(1:50)))-min(H_2_MAG(H(1:50)))	Amin = -max(H_2_MAG(H(101:end)))	zoom on				