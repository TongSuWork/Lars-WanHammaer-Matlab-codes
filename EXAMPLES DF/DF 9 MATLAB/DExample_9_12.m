	% Example 9.12	Norder = 6;	f0 = 50; 	% for Europe and 60 for USA		fsample = 800;	wTnotch = [1 3 5]*f0*2*pi/800;	BWnotch = [1 3 5]*4*2*pi/800;	[G, Z, P] = MULTIPLE_NOTCH_IIR(wTnotch, BWnotch, Norder)	wT = linspace(0,pi,10000);	H = PZ_2_FREQ_Z(G, Z, P, wT);	subplot(2,1,1)	PLOT_MAG_Z_dB(wT, H, pi, 80, 'H')