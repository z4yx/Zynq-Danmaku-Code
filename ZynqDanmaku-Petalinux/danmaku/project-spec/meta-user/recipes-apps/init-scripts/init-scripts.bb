#
# This file is the init-scripts recipe.
#

SUMMARY = "Simple init-scripts application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://boot_by_args \
        file://selector \
	    file://Makefile \
		"

S = "${WORKDIR}"

do_compile() {
	     oe_runmake
}

do_install() {
         install -m 0755 boot_by_args ${D}
	     install -m 0755 selector     ${D}
}
