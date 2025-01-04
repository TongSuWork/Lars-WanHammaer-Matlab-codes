	% Example 12.29 N=9	clear all	close all	clc	% CT Wave Digital Filter	fs = 16; lw = 2; fn = 'times'; 			WcT = 0.55*pi; WsT = 0.6*pi; Amax = 0.1;Amin = 65;		N = CA_ORDER_Z(WcT, WsT, Amax, Amin);	N = 9;			% We MUST select an odd order	%	figure(1)	[G, Z, R_ZEROS, P, WsnewT] = CA_POLES_Z(WcT, WsT, Amax, Amin, N);		%	PLOT_PZ_Z(Z, P)		alfa = CT_TREE_WDF_LP(P);	a11 = alfa(1,1);	a22 = alfa(2,2);	a23 = alfa(2,3);	a32 = alfa(3,2);	a33 = alfa(3,3);	a42 = alfa(4,2);	a43 = alfa(4,3);	a52 = alfa(5,2);	a53 = alfa(5,3);	wT = linspace(0, pi, 1000); 		delta = zeros(1,9);	alfa = [a11 a22 a23 a32 a33 a42 a43 a52 a53];	c1=1; c2= 1; c3=1/2; c4= 1; c5 = 1/4; c6 = 4;  c7 = 1; cp3 = 1; cp4 =  1;		A = zeros(17,17); B= zeros(17,1); C = zeros(1,17);	Wd = 9; WX = 2^Wd;	alfa0 = round(alfa*WX);	n1=7;	n2=4;	TempCost0 = 1000;  	A = zeros(17,17); B= zeros(17,1); C = zeros(1,17);%	for nn = 1:1		delta = RANDOM('Discrete Uniform',n1,1,9)-n2;		Coeff = alfa0 + delta; 		% Coeff = alfa0		a11 = Coeff(1)/WX;		a22 = Coeff(2)/WX;		a23 = Coeff(3)/WX;		a32 = Coeff(4)/WX;		a33 = Coeff(5)/WX;		a42 = Coeff(6)/WX;		a43 = Coeff(7)/WX;		a52 = Coeff(8)/WX;		a53 = Coeff(9)/WX;					a11=345/1024; 		a22 = 453/1024; 	a23 = 443/512;		a32 = 410/512;	a33 = 213/256;		a42 = 33/32;	a43 = 829/1024; 		a52 = 1171/1024; 	a53 = 13/16;				% 1 v1 2 v21 3 v22 4 Vp11 5 Vp12 6 V31 7 v32 8 vp21 9 vp22 10 v41 11 v42 12 vp31 13 vp32 14 v51 15 v52 16 vp41 17 vp42		A(1,1) = 1-2*a11;	% V1		A(2,3)= a22; A(2,2) = 1-a22; 	A(2,5)= -a22*c2; A(2,4) = -a22*c2;	% V21		A(3,3) =(a23-1); A(3,2) = -a23; A(3,5) = -a23*c2; A(3,4) = -a23*c2;	% V22		A(4,1) = -a11;	% Vp11		A(5,1) = a11;	% Vp12		A(6,7) = a32; A(6,6) = 1-a32; 	A(6,9) = -a32*c3; A(6,8) = -a32*c3;	% V31		A(7,7) = a33-1; A(7,6) = -a33; 	A(7,9) = -a33*c3; A(7,8) = -a33*c3;	% V32		A(8,3) = (2-a23-a22)/2;  A(8,2) = (a23+a22-2)/2; A(8,5) = (a23+a22-2)*c2/2; A(8,4) = (a23+a22)*c2/2;	% Vp21		A(9,3) = (a23+a22-2)/2;  A(9,2) = (2-a23-a22)/2; A(9,5) = -(a23+a22)*c2/2;  A(9,4) = (2-a23-a22)*c2/2;	% Vp22		A(10,11) = a42; A(10,10) = 1-a42;  A(10,13) = -a42*c4; A(10,12) = -a42*c4;	% V41		A(11,11) = a43-1; A(11,10) = -a43; A(11,13) = -a43*c4; A(11,12) = -a43*c4;	% V42		A(12,7) = (2-a33-a32)/2; A(12,6) = (a33+a32-2)/2; A(12,9) = (a33+a32-2)*c3/2; A(12,8) = (a33+a32)*c3/2; 	% Vp31		A(13,7) = (a33+a32-2)/2; A(13,6) = (2-a33-a32)/2; A(13,9) = -(a33+a32)*c3/2;  A(13,8) = (2-a33-a32)*c3/2;	% Vp32		A(14,15) = a52; A(14,14) = 1-a52;  A(14,17) = -a52*c5; A(14,16) = -a52*c5;	% v51		A(15,15) = a53-1; A(15,14) = -a53; A(15,17) = -a53*c5; A(15,16) = -a53*c5;	% V52		A(16,11) = (2-a43-a42)/2; A(16,10) = (a43+a42-2)/2; A(16,13) = (a43+a42-2)*c4/2; A(16,12) = (a43+a42)*c4/2;;	% vp41		A(17,11) = (a43+a42-2)/2; A(17,10) = (2-a43-a42)/2; A(17,13) = -(a43+a42)*c4/2;  A(17,12) = (2-a43-a42)*c4/2;	% vp42				B(1,1) = 2*(1-a11)*c1; B(4,1) = (1-a11)*c1; B(5,1) = a11*c1; 		C(1,15) = (2-a53-a52)*c6/2; C(1,14) = (a53+a52-2)*c6/2; C(1,17) =(a53+a52)*c5*c6/2; C(1,16) = (a53+a52-2)*c5*c6/2;					D = 0;			C = 2*C;		x = 1; v = zeros(17,1); 		noise = 0;		%for m = 1:17		%v = zeros(17,1);		%v(m,1) = 1;		for n = 1:444			h(n) = C*v + D*x;			v = A*v + B*x;					x = 0; 				noise = noise + h(n)^2;		end			%z = z+ noise		%	end		noise				warning off		%	figure(2)		h(1) =[];h(1) =[];h(1) =[];h(1) =[];		[G, Z, P] = IMPULSE_2_P_Z(h, 9);		Att = PZ_2_ATT_Z(G, Z, P, wT); 			Att = Att-min(Att);		PLOT_ATT_Z(wT, Att, pi, 80)		grid on		% Noise		G = C'*C;		for n = 1:40			G = A'*G*A + C'*C;		end		G = A'*G*A + C'*C;		sigma = 0		for n = 1:9			sigma = sigma + G(n,n);		end		sigma		