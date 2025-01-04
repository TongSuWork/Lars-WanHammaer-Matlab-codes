	% Requirement for the lowpass Cauer filter	Wc = 2; Ws = 5;  Amin = 60;	% Compute minimum required filter order	N = CA_CONST_R_ORDER_S(Wc, Ws, Amin)	% Re-run the program after selecting an integer	N = 7	% Compute the gain constant, zeros, and poles	[G, Z, R_ZEROS, P, Ws] = CA_CONST_R_POLES_S(Wc, Ws, Amin, N)		figure(1); xmax = 1; xmin = -5; ymax = 6;		alfa = linspace(pi/2, 3*pi/2, 200);	plot(sqrt(Wc*Ws)*cos(alfa), sqrt(Wc*Ws)*sin(alfa),'-','linewidth', 1);hold on	PLOT_PZ_S(Z, P, Wc, Ws, xmin, xmax, ymax); % Plot zeros, and poles	zoom on		omega = linspace(0, 10, 1000); 	H = PZ_2_FREQ_S(G, Z, P, omega);	% Compute the frequency response	Att = MAG_2_ATT(H);					% Compute the attenuation	Tg = PZ_2_TG_S(G, Z, P, omega); 	% Compute the group delay	figure(2)	PLOT_ATT_TG_S(Att, Tg, omega, 80, 4);		% Standard settings	fs = 16; 		% Font size	lw = 2; 		% Linewidth	fn = 'times'; 	% Font		text(4.5, 2,'Attenuation','FontName',fn,'FontSize',fs);	text(0.25, 2,'Group Delay','FontName',fn,'FontSize',fs);	