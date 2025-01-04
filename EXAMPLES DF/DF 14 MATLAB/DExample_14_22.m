	% DExample 14.22	close all	clear all	clc	N = 16;				% Decimation factor	K = 3; wTaxis = 0.1*pi;  	wT = linspace(eps, wTaxis, 1000);	Hc = (sin(wT*N)./(N*sin(wT))).^K;	% Kth-order sinc-decimator									subplot('position', [0.1 0.4 0.88 0.5]);	PLOT_MAG_Z_dB(wT, Hc, wTaxis, 50, 'H'), hold on	Nc = 17;			% FIR compensator of order N = Nc-1	h = CIC_COMP_MF(K, N, Nc);	wTH = linspace(0, N*wTaxis, 1000);	% Frequency response at	H = freqz(h,1,wTH);					% higher sampling rate	plot(wT, H_2_MAG(abs(H)),'linewidth',1); hold on	plot(wT, H_2_MAG(abs(H.*Hc)),'linewidth',2); 