# See 00INSTALL for instructions.

# Tweak this configuration to your preferences:
PREFIX ?= /usr/local
INSTALL_BIN ?= ${PREFIX}/bin
INSTALL_SOURCE ?= ${PREFIX}/share/common-lisp/source/cl-launch
INSTALL_SYSTEMS ?= ${PREFIX}/share/common-lisp/systems
LISPS ?= sbcl clisp ccl ecl cmucl gclcvs lispworks allegro gcl

# No user-serviceable part below
CL_LAUNCH := ./cl-launch.sh

install: install_binary install_source install_system

install_binary: install_binary_standalone

install_source:
	@echo "Installing Lisp source code for cl-launch in ${INSTALL_SOURCE}"
	@mkdir -p ${INSTALL_SOURCE}/
	@${CL_LAUNCH} --include ${INSTALL_SOURCE} -B install_path > /dev/null

install_system: install_source
	@echo "Linking .asd file for cl-launch into ${INSTALL_SYSTEMS}/"
	@mkdir -p ${INSTALL_SYSTEMS}/
	@if [ `dirname ${INSTALL_SYSTEMS}`/source/cl-launch = ${INSTALL_SOURCE} ] ; then \
		ln -sf ../source/cl-launch/cl-launch.asd ${INSTALL_SYSTEMS}/ ; \
	else \
		ln -sf ${INSTALL_SOURCE}/cl-launch.asd ${INSTALL_SYSTEMS}/ ; \
	fi

install_binary_standalone:
	@echo "Installing a standalone binary of cl-launch in ${INSTALL_BIN}/"
	@sh ./cl-launch.sh --no-include --no-rc \
		--lisp '$(LISPS)' \
		--output ${INSTALL_BIN}/cl-launch -B install_bin > /dev/null

install-with-include: install_binary_with_include install_source install_system

install_binary_with_include:
	@echo "Installing a binary of cl-launch in ${INSTALL_BIN}/"
	@echo "that will (by default) link its output to the code in ${INSTALL_SOURCE}"
	@sh ./cl-launch.sh --include ${INSTALL_SOURCE} --rc \
		--lisp '$(LISPS)' \
		--output ${INSTALL_BIN}/cl-launch -B install_bin > /dev/null

clean:
	-rm -f build.xcvb cl-launch cl-launch.asd launcher.lisp wrapper.sh
	-cd debian ; rm -f cl-launch.debhelper.log cl-launch.postinst.debhelper cl-launch.prerm.debhelper cl-launch.substvars files

mrproper: clean
	-rm -rf debian/cl-launch .pc/ build-stamp debian/patches/ debian/debhelper.log # debian crap


debian-package:
	git-buildpackage --git-debian-branch=master --git-upstream-branch=RELEASE --git-tag --git-retag

# This fits my own system. YMMV. Try make install for a more traditional install
reinstall:
	make install_system PREFIX=$${HOME}/.local
