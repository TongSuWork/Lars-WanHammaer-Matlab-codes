	% EXAMPLE 5.25	clear all	close all	clc		N = 44;	L = 10;	wsT = 0.2*pi;		h = FLAT_LP_FIR_1(N,L,wsT); % case wsT	wT = linspace(0,pi, 1000);	H = freqz(h,1, wT);	subplot(2,1,1)	PLOT_MAG_Z_dB(wT, H, pi, 80, 'H')	dsu = 0.01; dsl = -dsu;	h = FLAT_LP_FIR_2(N,L,dsl, dsu); % case d	wT = linspace(0,pi, 1000);	H = freqz(h,1, wT);	subplot(2,1,2)	PLOT_MAG_Z_dB(wT, H, pi, 80, 'H')				