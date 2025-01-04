		function [a1, a2, p, q] = MAX_FLAT_WDF(K, L, d)				% Computes the transfer function for a WDF lattice structure with		% maximally flat magnitude response.				% Reference		%	I.W. Selesnick: Low-Pass Filters Realzable as All-Pass Sums: 		%	Design via a New Flat Delay Filter, IEEE Trans. on Circuits 		%	and Systems, Vol. 46, No. 1, pp. 40-50, Jan. 1999.				%	K, L: Number of constraints at wT = 0 and � rad		%	Note the conditions must satisfy		%	(i) abs(K-L) +1 <= d <= K+L+1		%	(ii) d must be the same parity as K+L+1		%	a1, a2: denominators of the allpass filters		% 	p/q: overall transfer function				% Check for input validity		b1 = (abs(K-L) + 1 <= d) & (d <= K+L+1)		b2 = rem(K+L+1-d,2) == 0;		if ~(b1 & b2)			disp('For this K and L, d must be of one of the following:');			disp((abs(K-L) + 1):2:(K+L+1));			break		end		[tmp, a] = FLATDELAY(K, L, (d-K-L)/2);		rts = roots(a);		v = abs(rts) < 1		a1 = real(poly(rts(v))); 		% Roots inside unit circle		a2 = real(poly(1./rts(~v)));	% Roots osutside unit circle				% Compute overall transfre function p/q		p = [zeros(1,d), a] + [a(K+L+1:-1:1) zeros(1,d)];		q = conv(a1, a2);		p = p*sum(q)/sum(p);	% Normalize		