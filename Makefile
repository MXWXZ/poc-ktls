obj-m += tls.o
tls-y := tls_main.o tls_sw.o
tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
LUNATIK := lunatik/lua

subdir-ccflags-y := -I${PWD}/${LUNATIK} \
	-Wall \
	-D_KERNEL \
        -D_MODULE \
	-D'CHAR_BIT=(8)' \
	-D'MIN=min' \
	-D'MAX=max' \
	-D'UCHAR_MAX=(255)' \
	-D'UINT64_MAX=((u64)~0ULL)'

obj-y += lunatik/

KERNEL_DIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	make -C $(KERNEL_DIR) M=$(PWD) modules
	make -C /lib/modules/${shell uname -r}/build M=${PWD} CONFIG_LUNATIK=m
	gcc -o test test.c
clean:
	make -C $(KERNEL_DIR) M=$(PWD) clean
