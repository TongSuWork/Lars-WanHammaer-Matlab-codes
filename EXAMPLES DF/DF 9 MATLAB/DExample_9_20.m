	% EXAMPLE 9.20	clear all	close all	N = 7;			wT0 = linspace(0, 0.2*pi, 10*N);	% Band of interest	Tg0 = 2*N;		% Initial guess of the average group delay	[G, Z, P, Tg0] = EQ_TG(Tg0, wT0, N);	wT = linspace(0, pi, 1000);	Omega = [linspace(0, 0.2*pi, 200),linspace(0.3*pi, pi, 200)];	F1 = abs(PZ_2_FREQ_Z(G, Z, P, linspace(0, 0.2*pi, 200)))';	F2 = abs(PZ_2_FREQ_Z(G, Z, P, linspace(0.3*pi, pi, 200)))';	F = [F1;F2];	D1 = ones(200, 1); D2 = zeros(200,1);	D = [D1;D2];		NFIR = 18;	% Assume even order	N = NFIR/2;		M = length(Omega); k = 1:N; wT0 = Omega(:); D = D(:);	W = eye(M);   		for n = 201:400		W(n,n) = 10-0.022*n;	% Ad hoc weighting	end	C = cos(wT0*k);	A = diag(F)*[ones(M,1) 2*C];	h = W*A\(W*D);	g = h;	g(1) = [];	H = h(1)*ones(length(wT),1) + 2*cos(wT'*k)*g;		% Compute poles and zeros	Zall = roots([flipud(h); g]);	Pall = [zeros(length(Zall)-length(P),1); P];	G = prod(1-Pall)/prod(1-Zall);		figure(1)	PLOT_PZ_Z(Zall, Pall)		figure(2)		Att = PZ_2_ATT_Z(G, Zall, Pall, wT);	Taug = PZ_2_TG_Z(G, Zall, Pall, wT);	PLOT_ATT_TG_Z(Att, Taug, wT, 60, 20)	fs = 16; % Font size	lw = 1; % Linewidth	fn = 'times'; % Font	text(0.5, 11.5,'{\it\tau_g}({\ite^j^\omega^T })','FontName',fn,'FontSize',fs);		text(1.5, 13,'{\itA}({\ite^j^\omega^T})','FontName',fn,'FontSize',fs);