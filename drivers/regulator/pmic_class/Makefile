# SPDX-License-Identifier: GPL-2.0
obj-$(CONFIG_DRV_SAMSUNG_PMIC) += pmic_class.o

GCOV_PROFILE := $(CONFIG_KUNIT)
ifeq ($(CONFIG_KUNIT), y)
obj-y += test/
endif

ccflags-y := -Wformat
