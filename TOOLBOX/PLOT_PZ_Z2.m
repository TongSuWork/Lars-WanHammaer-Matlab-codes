	function PLOT_PZ_Z2(Z, P)	 	%	Plots the poles and zeros in the z-plane 	%	Toolbox for DIGITAL FILTERS USING MATLAB		% Author: 			Lars Wanhammar 2004-11-15	% Modified by: 	 	LW 2005-05-03, 2010-11-16	% Copyright:		by authors - not released for commercial use	% Version:			1 	% Known bugs:			% Report bugs to:	Wanhammar@gmail.com 	%========================================================		% Standard settings	fs = 16; % Font size	lw = 1; % Linewidth	fn = 'times'; % Font	%========================================================	% Determine the size of the plot	zoomout = 1.2;				% May be changed to get a neater plot	if isempty(Z)		xmax = 2.2;		xmin = -1.1;		ymax = 1.1;	else		xmax = max(2.5, zoomout*max(real(Z)));		xmin = min(-1.1, zoomout*min(real(Z)));		ymax = max(1.1, zoomout*max(imag(Z)));	end	box on;	hold on	ax = newplot;	set(ax,'ylim',[-ymax ymax],'fontsize',fs,'linewidth', lw, 'fontname', fn);	set(ax,'xlim',[xmin xmax]);	%	set(get(ax,'xlabel'),'string','Real part','fontsize',fs,'fontname', fn)	%	set(get(ax,'ylabel'),'string','Imaginary part','fontsize', fs,'fontname', fn)	% Plot the unit circle	alfa = linspace(0, 2*pi, 200);	plot(cos(alfa), sin(alfa),'-','linewidth', lw);	% Plot axes	yx = max(1.05, 0.9*ymax);	line([0 0],[-yx, yx],'linewidth', lw);	line([min(-1.05, 0.95*xmin) max(1.05, 0.95*xmax)], [0 0],'linewidth', lw);	daspect([1 1 1]);		% Check for multiple poles and zeros	% Determine first unique roots and their multiplicity	[unique_zeros, multiplicity_Z] = UNIQUE_ROOTS(Z);	% Make real roots sligthly complex	tol = 1.0e-14; 	unique_zeros = unique_zeros+j*tol;		plot(unique_zeros,'o','markersize', fs/2,'linewidth', 2);	for a = 1:length(unique_zeros) 		% Plot multiplicity of the zeros		position = unique_zeros(a) + lw*(0.04+j*0.06);		if (multiplicity_Z(a) > 1)			text(real(position), imag(position), int2str(multiplicity_Z(a)),'fontsize', fs-2)		end	end	[unique_poles, multiplicity_P] = UNIQUE_ROOTS(P);	unique_poles = unique_poles+j*tol;	plot(unique_poles, 'x','markersize', fs,'linewidth', 2);	for a = 1:length(unique_poles) 		% Plot multiplicity of the poles		position = unique_poles(a) + lw*(0.03+j*0.12);		if (multiplicity_P(a) > 1)			text(real(position), imag(position), int2str(multiplicity_P(a)),'fontsize', fs-2)		end	end	% Check for zeros at infinity and cusality	Zinf = length(P) - length(Z);	if Zinf < 0 		disp('WARNING � Noncausal transfer function');	end	grid on;	box on;	