	% Synthesis of an analog lowpass Butterworth filter	% Requirement for the lowpass filter	wc = 20000; ws = 28000; Amax = 0.28029; Amin = 40;	% Compute minimum required filter order	N = CH_ORDER_S(wc, ws, Amax, Amin)	% Re-run the program after selecting N = integer	N = 8;	% Compute the gain constant, zeros, and poles	[G, Z, R_ZEROS, P, wWsnew] = CH_I_POLES_S(wc, ws, Amax, Amin, N)	[G, Z, R_ZEROS, P, wsnew] = CH_I_C_POLES_S(G, Z, P, wc, ws, N)		% Plot zeros, and poles	% Set suitable axes	figure(1); xmax = 5000; xmin = -40000; ymax = 40000;	PLOT_PZ_S(Z, P, wc, ws, xmin, xmax, ymax)	% Select resolution and the frequency range of the plot	% 1000 values between 0 and 5e4 rad/s	omega = linspace(0, 5e4, 1000); 	% Compute the frequency response	H = PZ_2_FREQ_S(G, Z, P, omega);	% Compute the attenuation	Att = MAG_2_ATT(H);				% Compute the group delay	Tg = PZ_2_TG_S(G, Z, P, omega);	% Plot in the same figure	figure(2)	PLOT_ATT_TG_S(Att, Tg, omega, 60, 1.5*10^-3);	zoom on	fs = 16; % Font size	lw = 2; % Linewidth	fn = 'times'; % Font	text(30000, 1*10^-3,'Attenuation','FontName',fn,'FontSize',fs);	text(2000, 0.5*10^-3,'Group Delay','FontName',fn,'FontSize',fs);		% Compute the impulse and step responses over from 0 to tmax	tmax = 2*10^-3;	t_axis = [0:0.01*tmax:tmax];	[h, dirac0, t_axis] = PZ_2_IMPULSE_RESPONSE_S(G, Z, P, t_axis);		[s_of_t, t_axis] = PZ_2_STEP_RESPONSE_S(G, Z, P, t_axis);	% Plot the impulse and step responses in the same figure	% Scale the impulse response with h_scale	h_scale = 5*10^-5; ymin = -0.4; ymax = 1.3;	PLOT_h_s_S(h, h_scale, s_of_t, t_axis, tmax, ymin, ymax)	zoom on	