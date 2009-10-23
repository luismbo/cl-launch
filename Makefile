# See 00INSTALL for instructions.

# Tweak this configuration to your preferences:
PREFIX ?= /usr/local
INSTALL_BIN ?= ${PREFIX}/bin
INSTALL_SOURCE ?= ${PREFIX}/share/common-lisp/source
INSTALL_SYSTEMS ?= ${PREFIX}/share/common-lisp/systems
LISPS ?= sbcl clisp ccl ecl cmucl gclcvs lispworks allegro gcl

# No user-serviceable part below
CL_LAUNCH := ./cl-launch.sh

install: install_binary install_source install_system

install_binary: install_binary_standalone

install_source:
	mkdir -p ${INSTALL_SOURCE}/
	${CL_LAUNCH} --include ${INSTALL_SOURCE}/cl-launch -B install_path

install_system: install_source
	mkdir -p ${INSTALL_SYSTEMS}/
	if [ `dirname ${INSTALL_SYSTEMS}`/source = ${INSTALL_SOURCE} ] ; then \
		ln -sf ../source/cl-launch/cl-launch.asd ${INSTALL_SYSTEMS}/ ; \
	else \
		ln -sf ${INSTALL_SOURCE}/cl-launch.asd ${INSTALL_SYSTEMS}/ ; \
	fi

install_binary_standalone:
	sh ./cl-launch.sh --no-include --no-rc \
		--lisp '$(LISPS)' \
		--output ${INSTALL_BIN}/cl-launch -B install_bin

install-with-include: install_binary_with_include install_source install_system

install_binary_with_include:
	sh ./cl-launch.sh --include ${INSTALL_SOURCE} --rc \
		--lisp '$(LISPS)' \
		--output ${INSTALL_BIN}/cl-launch -B install_bin
