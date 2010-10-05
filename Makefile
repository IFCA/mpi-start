# Makefile for MPI_START
VERSION=$(shell cat VERSION)
DESTDIR=
PREFIX=/opt/i2g
NAME_PREFIX=i2g

all:
	$(MAKE) -C src all 
	$(MAKE) -C modules all
	$(MAKE) -C templates all
	$(MAKE) -C docs all

clean:
	rm -f *.tar.gz
	rm -rf bin etc
	$(MAKE) -C src clean
	$(MAKE) -C modules clean
	$(MAKE) -C templates clean
	$(MAKE) -C docs clean

distclean:clean

install:
	mkdir -p $(DESTDIR)/$(PREFIX)/bin
	mkdir -p $(DESTDIR)/$(PREFIX)/etc/mpi-start
	mkdir -p $(DESTDIR)/etc
	install COPYING $(DESTDIR)/$(PREFIX)/etc/mpi-start
	$(MAKE) -C src install
	$(MAKE) -C modules install
	$(MAKE) -C templates install
	$(MAKE) -C docs install
	mkdir -p $(DESTDIR)/etc/profile.d
	echo "export I2G_MPI_START=$(PREFIX)/bin/mpi-start" > $(DESTDIR)/etc/profile.d/mpi_start.sh
	echo "setenv I2G_MPI_START $(PREFIX)/bin/mpi-start" > $(DESTDIR)/etc/profile.d/mpi_start.csh

tarball:all
	$(MAKE) install PREFIX="" DESTDIR=`pwd` 
	tar czvf mpi-start-$(VERSION).tar.gz bin/* etc/*

dist:	
	rm -rf $(NAME_PREFIX)-mpi-start-$(VERSION)
	hg archive $(NAME_PREFIX)-mpi-start-$(VERSION)
	sed -e "s/@NAME_PREFIX@/$(NAME_PREFIX)-/" -e "s/@VERSION@/$(VERSION)/" mpi-start.spec.in > $(NAME_PREFIX)-mpi-start-$(VERSION)/$(NAME_PREFIX)-mpi-start-$(VERSION).spec
	tar cvzf $(NAME_PREFIX)-mpi-start-$(VERSION).tar.gz $(NAME_PREFIX)-mpi-start-$(VERSION)
	rm -rf $(NAME_PREFIX)-mpi-start-$(VERSION)

rpm: dist
	mkdir -p rpm/SOURCES rpm/SRPMS rpm/SPECS rpm/BUILD rpm/RPMS
	rpmbuild --define "_topdir `pwd`/rpm" --define "mpi-start-prefix $(PREFIX)" -ta $(NAME_PREFIX)-mpi-start-$(VERSION).tar.gz


export VERSION
export PREFIX
export DESTDIR
