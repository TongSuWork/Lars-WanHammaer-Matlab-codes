	function BNO = BERNO(k)	 		%  Bernoulli numbers vis via zeta function		%	Reference:	% 	G. Molnar and M. Vucic: Closed-form design of 	%	CIC compensators based on maximally flat error 	%	criterion, IEEE Trans. on Circuits and Systems, 	%	II, Vol 58, No, 12, pp. 926-930, Dec. 2011.		if k < 19 		B = [1/6,-1/30,1/42,-1/30,5/66,-691/2730,7/6,-3617/510,43867/798];		BNO = B(k);	else		BNO = 2*(-1)^(k-1)*prod(1:2*k)/(2*pi)^(2*k)*zeta(2*k);	end	