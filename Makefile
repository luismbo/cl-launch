# You may want to e.g.
#   sudo make install PREFIX=/usr
# Personally, I have a ./reinstall script that does
#   make install_system PREFIX=$HOME/.local
# and if not for a judicious symlink from $HOME/bin/cl-launch to my checkout,
# it would also do
#   make install_binary PREFIX=$HOME
# Of course you should adjust your PATH and your asdf:*central-registry*
# coherently with where you install cl-launch.
#
# If you just want to see what cl-launch will create without installing it to the final destination,
# you can:
#   mkdir -p build/bin build/systems build/source ;
#   make install INSTALL_BIN=${PWD}/build/bin INSTALL_SOURCE=${PWD}/build/source INSTALL_SYSTEMS=${PWD}/build/systems

PREFIX ?= /usr/local
INSTALL_BIN ?= ${PREFIX}/bin
INSTALL_SOURCE ?= ${PREFIX}/share/common-lisp/source
INSTALL_SYSTEMS ?= ${PREFIX}/share/common-lisp/systems
LISPS ?= sbcl clisp ccl ecl cmucl gclcvs lispworks allegro gcl

CL_LAUNCH := ./cl-launch.sh

install: install_binary install_source install_system

install_binary: install_binary_standalone

install_source:
	${CL_LAUNCH} --include ${INSTALL_SOURCE}/cl-launch -B install_path

install_system: install_source
	if [ `dirname $(INSTALL_SYSTEMS)`/source = $(INSTALL_SOURCE) ] ; then \
		ln -sf ../source/cl-launch.asd $(INSTALL_SYSTEMS)/ ; \
	else \
		ln -sf $(INSTALL_SOURCE)/cl-launch.asd $(INSTALL_SYSTEMS)/ ; \
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
