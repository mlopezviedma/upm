ifndef PREFIX
  PREFIX = /usr
endif

ifndef HOMEDIR
  HOMEDIR = /var/pkg
endif

ifndef LIBEXECDIR
  LIBEXECDIR = /usr/libexec/upm
endif

ifndef GROUPSCHEME
  GROUPSCHEME = install
endif

SYSCONFIGDIR = /etc

install:
	test -d ${HOMEDIR} || mkdir -pv ${HOMEDIR}
	test -d ${LIBEXECDIR} || mkdir -pv ${LIBEXECDIR}
	test -d ${PREFIX}/lib/upm || mkdir -pv ${PREFIX}/lib/upm
	test -d ${SYSCONFIGDIR}/upm/skel || mkdir -pv ${SYSCONFIGDIR}/upm/skel
	test -d ${SYSCONFIGDIR}/upm/hooks || mkdir -pv ${SYSCONFIGDIR}/upm/hooks
	install -Dv -m 755 src/upm ${PREFIX}/bin/upm
	for f in 1 3 ; do \
		install -Dv -m 644 src/upm.$${f}.gz ${PREFIX}/share/man/man$${f}/upm.$${f}.gz ; \
	done
	for f in action check help message query ; do \
		install -Dv -m 644 src/$${f}_functions ${PREFIX}/lib/upm/$${f}_functions ; \
	done
	install -Dv -m 755 src/etc/build.sh ${SYSCONFIGDIR}/upm/build.sh
	for f in build.conf skel/.pkginfo ; do \
		install -Dv -m 644 src/etc/$${f} ${SYSCONFIGDIR}/upm/$${f} ; \
	done
	for f in upm.conf bashrc installdirs.lst ; do \
		install -Dv -m 644 --backup=numbered src/etc/$${f} ${SYSCONFIGDIR}/upm/$${f} ; \
	done
	for f in create exit fix login quit ; do \
		install -Dv -m 644 src/etc/hooks/$${f}.hook ${SYSCONFIGDIR}/upm/hooks/$${f}.hook ; \
	done
	ln -svf ${SYSCONFIGDIR}/upm/bashrc ${SYSCONFIGDIR}/upm/skel/.bashrc
	ln -svf ${SYSCONFIGDIR}/upm/bashrc ${SYSCONFIGDIR}/upm/skel/.bash_profile
	ln -svf ${SYSCONFIGDIR}/upm/build.sh ${SYSCONFIGDIR}/upm/skel/build.sh
	ln -svf .pkginfo ${SYSCONFIGDIR}/upm/skel/.project
	sed -i -e "s#PREFIX=#PREFIX=${PREFIX}#" \
		-e "s#HOMEDIR=#HOMEDIR=${HOMEDIR}#" \
		-e "s#LIBEXECDIR=#LIBEXECDIR=${LIBEXECDIR}#" \
		-e "s#GROUPSCHEME=#GROUPSCHEME=${GROUPSCHEME}#" \
		-e "s#INSTALLDIRSADMIN=#INSTALLDIRSADMIN=${INSTALLDIRSADMIN}#" \
		${SYSCONFIGDIR}/upm/upm.conf
	make --makefile Makefile.upmdb PREFIX=${PREFIX} install
