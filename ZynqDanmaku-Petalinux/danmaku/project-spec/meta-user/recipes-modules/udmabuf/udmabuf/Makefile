obj-m := udmabuf.o

SRC := $(shell pwd)
HOST_ARCH       ?= $(shell uname -m | sed -e s/arm.*/arm/ -e s/aarch64.*/arm64/)
ARCH            ?= $(shell uname -m | sed -e s/arm.*/arm/ -e s/aarch64.*/arm64/)

all:
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) M=$(SRC)

modules_install:
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) M=$(SRC) modules_install

clean:
	rm -f *.o *~ core .depend .*.cmd *.ko *.mod.c
	rm -f Module.markers Module.symvers modules.order
	rm -rf .tmp_versions Modules.symvers
