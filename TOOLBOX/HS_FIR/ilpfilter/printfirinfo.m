function printfirinfo(filtspec, ppspec, pphw, csspec, vmaspec, piperegs)
%printfirinfo(filtspec, ppspec, pphw, csspec, vmaspec, piperegs)
%
%Prints FIR complexity information
%Inputs:
%  filtspec - structure with fields
%    crep: coefficient representation
%    cterm: correction term
%    numphases: number of polyphase branches
%    wdata: data wordlength
%    wout: output wordlength
%    signeddata: signedness of data
%  ppspec
%  pphw
%  csspec
%  vmaspec

wout = filtspec.wout;
inbits = ppspec.inbits;
cterm = ppspec.cterm;
extraregs = pphw.extraregs;
extrafa = pphw.extrafa;
extraha = pphw.extraha;


disp ' '
disp(sprintf('Number of out bits: %d', wout));
disp ' '
disp 'Initial bits in binary representation:'
for c = 1:size(inbits, 1)
	if sum(inbits(c, :)) ~= 0
		disp(sprintf('Level %d:%s', c, sprintf(' %2d', inbits(c, :))));
	end
end
disp(sprintf('Constant term:   %s', sprintf(' %2d', cterm)));
disp(sprintf('Structural regs: %d', extraregs));
disp(sprintf('Structural FA:   %d', extrafa));
disp(sprintf('Structural HA:   %d', extraha));
disp ' '
disp(sprintf('Total number of partial products: %d', sum(sum(csspec.ppin))+sum(sum(csspec.cin))));
disp(sprintf('CS tree regs: %d', sum(sum(csspec.regs))));
disp(sprintf('CS tree FA:   %d', sum(sum(csspec.fa))));
disp(sprintf('CS tree HA:   %d', sum(sum(csspec.ha))));
disp(sprintf('Number of stages: %d', sum(any(csspec.regs, 2))));
disp(sprintf('CS output vector:%s', sprintf(' %d', csspec.bout)));
disp ' '
disp(sprintf('VMA regs: %d', sum(sum(vmaspec.regs))));
disp(sprintf('VMA FA:   %d', sum(sum(vmaspec.fa))));
disp(sprintf('VMA HA:   %d', sum(sum(vmaspec.ha))));
disp ' '
disp(sprintf('Filter pipeline delay: %d', piperegs));

