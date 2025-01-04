DIST=hsfir
VERSION=0.2

MSCIP=~/matlab/mscip
VHDLGEN=~/matlab/vhdlgen

DISTFILES=COPYING Makefile README TODO base csatree.mod \
		  firgenconf.m.template calccterm.m chooserep.m csdelay.m \
		  dectobin.m ex1_df.m ex2_tf.m ex3_mrdf.m ex4_mrtf.m ex5_dfsha.m \
		  ex6_tfsha.m ex7_opt.m fir_dec.m fir_multirate.m gencoeffreps.m \
		  gencslp.m genfirstim.m genmakefile.m genmsdcoeffs_int.m \
		  genmsdcoeffs.m gfir.m gfirvhdl.m hdlcompiface.m hdlcs.m \
		  hdlfir.m hdlfirref.m hdlfirtb.m hdlppdfc.m hdlppdf.m \
		  hdlpptfc.m hdlpptf.m hdlsha.m hdlsources.m hdlvmacs.m \
		  makecsdadda.m makecs.m makecsmap.m makecsmaps.m makecsopt.m \
		  makecsra.m makecswallace.m makepp.m makeppmap.m makeppspec.m \
		  maketree.m makevma.m makevmarc.m metabase.m meta.m optcstree.m \
		  parseopts.m pipedelay.m printcomplexity.m shareadders.m \
		  sincfilter.m symmetryadder.m treecomplexity.m vhdlbase.m

default:
	echo "make dist: create distribution file"

dist:
	mkdir ${DIST}
	cp -r ${DISTFILES} ${DIST}/
	cp ${VHDLGEN}/*.m ${DIST}/
	cp ${MSCIP}/*.m ${DIST}/
	tar zcf ${DIST}-${VERSION}.tar.gz ${DIST}
	rm -rf ${DIST}

