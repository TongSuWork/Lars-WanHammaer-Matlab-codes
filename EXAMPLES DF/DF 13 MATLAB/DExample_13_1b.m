	% Digital Filters Example 13.1	clear all	close all	clc	wcT = 0.045*pi; wsT = 0.05*pi; dc = 0.01; ds = 0.001;	[N, Be, D, W] = HERRMANN_LP_FIR_ORDER([wcT wsT], [dc ds])	M = 10; wT = linspace(0,pi,5000); 	% Model filter	[N, Be, D, W] = HERRMANN_LP_FIR_ORDER([M*wcT M*wsT], [dc/2 ds]);	% Estimated N = 111; Required N = 113	N = 113;	[g, Err] = REMEZ_FIR(N, Be, D, W, 'm'); G = freqz(g,1,wT);	% Masking filter	[N, Be, D, W] = HERRMANN_LP_FIR_ORDER([wcT 2*pi/M-wsT], [dc/2 ds]);	% Estimated N = 53; Required N = 57	N = 57;	[f, Err] = REMEZ_FIR(N, Be, D, W, 'm'); F = freqz(f,1,wT);	% Periodic filter	GM = freqz(g,1,wT*M); H = GM.*F;	figure(1)	subplot(2,1,1), PLOT_MAG_Z_dB(wT,G, pi, 90, 'G')	subplot(2,1,2), PLOT_MAG_Z_dB(wT, GM, pi, 90, 'G_M')	figure(2)	subplot(2,1,1), PLOT_MAG_Z_dB(wT, F, pi, 90, 'F')	subplot(2,1,2), PLOT_MAG_Z_dB(wT, H, pi, 90, 'H')	 