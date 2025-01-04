/* Complexity costs */
param UCost_FA, integer, >= 0;
param UCost_HA, integer, >= 0;
param UCost_reg, integer, >= 0;
param UCost_bit, integer, >= 0;

param NumConstrainedOut, integer, >= 0;


/* Parameters */
param AdderLevels, integer, > 0;
param Wordlength, integer, > 0;
param MaxHeight, integer, > 0;
set BitRange := {1..Wordlength};
set LevelRange := {0..AdderLevels};
set AdderRange := {0..AdderLevels-1};
param BitsIn{l in AdderRange, b in BitRange}, integer, >= 0;
param CTerm{b in BitRange}, integer, >= 0;

/* Check that AdderLevels is a multiple of MaxHeight
check AdderLevels/MaxHeight = floor(AdderLevels/MaxHeight);

/* Range specifications */
set RegLevels := {MaxHeight-1..AdderLevels-1 by MaxHeight};
set ConstrainedOutSet := {Wordlength-NumConstrainedOut+1..Wordlength};
set CInRange := {0..AdderLevels by MaxHeight};

/* Variables */
var bits{l in LevelRange, b in BitRange}, integer, >= 0;
var ibits{l in AdderRange, b in BitRange}, integer, >= 0;
var FA{l in AdderRange, b in BitRange}, integer, >= 0;
var HA{l in AdderRange, b in BitRange}, integer, >= 0;
var regs{l in RegLevels, b in BitRange}, integer, >= 0;
var carray{l in CInRange, b in BitRange}, integer >= 0;
var cinput{l in AdderRange, b in BitRange}, integer >= 0;
var inbits{l in AdderRange, b in BitRange}, integer >= 0;

/* CSA tree output */
var BitsOut{b in BitRange}, integer, >= 0;

/* Cost functions */
var Cost_FA, integer, >= 0;
var Cost_HA, integer, >= 0;
var Cost_regs, integer, >= 0;
var Cost_bits, integer, >= 0;
var Cost, integer, >= 0;

/* Optimization */
s.t. defoptfa1{a in AdderRange, b in BitRange}:
    FA[a,b] >= (bits[a,b]-2)/3;
s.t. defoptfa2{a in AdderRange, b in BitRange}:
    FA[a,b] <= bits[a,b]/3;
s.t. defoptha{a in AdderRange, b in BitRange}:
    HA[a,b] <= 1;

/* Interconnection for all bits except lsb */
s.t. defibits{l in AdderRange, b in 1..(Wordlength-1)}:
    ibits[l,b] = bits[l,b] - 2*FA[l,b] - HA[l,b] + FA[l,b+1] + HA[l,b+1];

/* Interconnection for lsb */
s.t. deflsbibits{l in AdderRange}:
    ibits[l,Wordlength] = bits[l,Wordlength] - 
            2*FA[l,Wordlength] - HA[l,Wordlength];

/* Definition of input bits (BitsIn and CTerm bits) */
s.t. definbits{l in AdderRange, b in BitRange}:
    inbits[l,b] = BitsIn[l,b] + cinput[l,b];

/* Definition of bits on top level */
s.t. deftopbits{b in BitRange}:
    bits[0,b] = inbits[0, b];

/* Definitien of bits on bottom level */
s.t. defbottombits{b in BitRange}:
	bits[AdderLevels,b] = ibits[AdderLevels-1,b];

/* Definition of other bits */
s.t. defbits{l in 0..AdderLevels-2, b in BitRange}:
    bits[l+1,b] = inbits[l+1,b] + ibits[l,b];

/* Define no intra-level dependencies, i.e., adders may only use bits from the level above */
s.t. leveldep{l in AdderRange, b in BitRange}:
    3*FA[l,b] + 2*HA[l,b] <= bits[l,b];

/* Define initial constant term in carray */
s.t. carraytop{b in BitRange}:
    carray[0, b] = CTerm[b];

/* Define constant term placement rules */
s.t. carraynoadd{l in 0..AdderLevels-MaxHeight by MaxHeight, b in BitRange}:
    carray[l+MaxHeight, b] <= carray[l, b];

/* Define constant term end rule: all terms must be added */
s.t. carrayfin{b in BitRange}:
    carray[AdderLevels, b] = 0;

/* Define constant term input */
s.t. defcinput{l in AdderRange, b in BitRange}:
    cinput[l,b] = if l in CInRange then carray[l,b] - carray[l+MaxHeight,b] else 0;

/* Define number of registers in the adder tree */
s.t. defregs{r in RegLevels, b in BitRange}: regs[r,b] = ibits[r,b];

/* Define output bits */
s.t. defbitsout{b in BitRange}: BitsOut[b] = bits[AdderLevels,b];

/* Constraint on number of output bits */
s.t. csoutbits{b in BitRange}: BitsOut[b] <= 
    if b in ConstrainedOutSet then 1 else 2;

/* Definitions of cost functions */
s.t. defcostfa: Cost_FA = sum{a in AdderRange, b in BitRange} UCost_FA * FA[a,b];
s.t. defcostha: Cost_HA = sum{a in AdderRange, b in BitRange} UCost_HA * HA[a,b];
s.t. defcostregs: Cost_regs = sum{r in RegLevels, b in BitRange} UCost_reg * regs[r,b];
s.t. defcostbits: Cost_bits = sum{a in AdderRange, b in BitRange} UCost_bit * bits[a,b];
s.t. defcost: Cost = Cost_FA + Cost_HA + Cost_regs + Cost_bits;

/* Objective */
minimize totalcost: Cost;

end;
