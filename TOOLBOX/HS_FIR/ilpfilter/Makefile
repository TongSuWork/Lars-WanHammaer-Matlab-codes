DIST=ilpfilter
DISTFILES=LICENSE Makefile README TODO csatree.mod dc.cmd parsesol.sh \
		  base calccterm.m chooserep.m csdelay.m dectobin.m exvhdl1.m \
		  exvhdl2.m exvhdl3.m exvhdl4.m exvhdl5.m \
		  firgenconf.m genbasevhdl_i.m genbasevhdl.m gencoeffreps.m \
		  gencslp.m gencsvhdlarchitecture.m gencsvhdlentity.m \
		  gencsvhdl.m gencsvhdlport.m gencsvhdlsignals.m gendcscript.m \
		  genfirrefvhdl.m genfirstim.m genfirtbvhdl.m genfirvhdl.m \
		  genmsdcoeffs_int.m genmsdcoeffs.m genppvhdl.m genppvhdlport.m \
		  gensimscript.m genstrucvhdl.m gensynthscript.m genvhdllibs.m \
		  idxmat.m makecsmap.m makedadda.m makeppgen.m makera.m \
		  makercvma.m makewallace.m metabase.m metadc.m meta.m \
		  numreps.m optcstree_i.m optcstree.m optparsesol.m polyphase.m \
		  printfirinfo.m sincfilter.m symmetryadder.m

default:
	echo "make dist: create distribution file"

dist:
	mkdir ${DIST}
	cp -r ${DISTFILES} ${DIST}/
	tar zcf ${DIST}.tar.gz ${DIST}
	rm -rf ${DIST}

