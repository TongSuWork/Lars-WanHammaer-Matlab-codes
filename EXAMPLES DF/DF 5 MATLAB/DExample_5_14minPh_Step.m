	% EXAMPLE 5.14 Minimum-Phase FIR Filter	% Compare step responses 	wcT =  0.3*pi;	wsT = 0.6*pi;	dc = 0.02;	ds = 0.0025;	AmaxS = 20*log10((1+dc)/(1-dc))	AminS = 20*log10((1+dc)/ds)	wT = [wcT wsT];	b = [1 0];	d = [dc ds];	N = 12; % N = 0 => uses remezord to estimate the order	% N > 0 overrides the estimation	[hMP, ZerosMP] = MIN_PHASE_LP_FIR(N, wT, d);		[N, Be, D, W] = HERRMANN_LP_FIR_ORDER(wT, d);	N 		% Estimated filter order	N = 16;	[hLP, ERR] = REMEZ_FIR(N, Be, D, W, 'm');	hLP = (1/(1+ERR))*hLP; 	% Normalize the max gain to 1	disp(['LP']);	ERR	sLP = hLP;	sMP = hMP;	sMP = [sMP zeros(1,4)];	for n = 2:N+1		sLP(n) = sLP(n) + sLP(n-1);		sMP(n) = sMP(n) + sMP(n-1);	end	figure(1)	subplot('position', [0.1 0.08 0.86 0.38])	PLOT_IMPULSE_RESPONSE_Z(sLP);	ylabel('Linear-phase {\its}({\itnT})','FontName', fn,'FontSize',fs);%	xlabel('n','FontName', fn,'FontSize',fs);	grid on;	axis([0 17 -0.1 1.2]);		subplot('position', [0.1 0.55 0.86 0.38])	PLOT_IMPULSE_RESPONSE_Z(sMP);	ylabel('Minimum-phase {\its}({\itnT})','FontName', fn,'FontSize',fs);%	xlabel(' ','FontName', fn,'FontSize',fs);	grid on;	axis([0 17 -0.1 1.2]);	 	%subplot('position', [0.1 0.04 0.86 0.42])