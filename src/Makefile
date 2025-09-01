UEFI_TARGET ?= RELEASE
# Specify DEBUG build for development
# UEFI_TARGET ?= DEBUG

.PHONY: all
all: build

PACKAGE_TOOL := edk2-non-osi/Platform/CIX/Sky1/PackageTool
DSC := $(shell find edk2-platforms/Platform/Radxa -mindepth 3 -maxdepth 3 -name "*.dsc" -type "f") \
	#    $(shell find edk2-platforms/Platform/CIX -mindepth 3 -maxdepth 3 -name "*.dsc" -type "f")

CIX_FLASH := $(foreach i, $(patsubst edk2-platforms/Platform/%.dsc,%,$(DSC)), Build/$(lastword $(subst /, ,$(i)))/$(UEFI_TARGET)_GCC5/cix_flash_all.bin) \
			 $(foreach i, $(patsubst edk2-platforms/Platform/%.dsc,%,$(DSC)), Build/$(lastword $(subst /, ,$(i)))/$(UEFI_TARGET)_GCC5/cix_flash_ota.bin)
.PHONY: build
build: $(CIX_FLASH)

.SILENT: help
.PHONY: help
help:
	echo "Supported targets:"
	echo "$(CIX_FLASH)"

Build/%/$(UEFI_TARGET)_GCC5/cix_flash_ota.bin: Build/%/$(UEFI_TARGET)_GCC5/Firmwares/bootloader3.img
	export CFG="$(shell find edk2*/Platform/ -mindepth 4 -maxdepth 4 -path "*/$*/spi_flash_config_ota.json" -type f)" && \
	export PATH_PACKAGE_TOOL="$(shell realpath "$(PACKAGE_TOOL)")" && \
	if [[ -f "$$CFG" ]]; then \
		echo "Found custom flash config."; \
		cp "$$CFG" Build/$*/$(UEFI_TARGET)_GCC5/; \
	else \
		cp "$$PATH_PACKAGE_TOOL/spi_flash_config_ota.json" Build/$*/$(UEFI_TARGET)_GCC5/; \
	fi

	export PATH_PACKAGE_TOOL="$(shell realpath "$(PACKAGE_TOOL)")" && \
	pushd "Build/$*/$(UEFI_TARGET)_GCC5/" && \
	"$$PATH_PACKAGE_TOOL/cix_package_tool" -c "./spi_flash_config_ota.json" -O "./cix_flash_ota.bin" && \
	popd

# MEM_CFG_MEMFREQ ?= 2750
MEM_CFG_MEMFREQ ?= 3000

Build/%/$(UEFI_TARGET)_GCC5/cix_flash_all.bin: Build/%/$(UEFI_TARGET)_GCC5/Firmwares/bootloader3.img
	export MEM="$(shell find edk2*/Platform/ -mindepth 4 -maxdepth 4 -path "*/$*/mem_config" -type d)" && \
	if [[ -d "$$MEM" ]]; then \
		echo "Found custom memory configuration."; \
		make -C "$$MEM" -j$(shell nproc) -e CFLAG:="-DMEM_CFG_MEMFREQ=$(MEM_CFG_MEMFREQ)" clean main; \
		mv "$$MEM/memory_config.bin" Build/$*/$(UEFI_TARGET)_GCC5/Firmwares/; \
	fi
	export PM="$(shell find edk2*/Platform/ -mindepth 4 -maxdepth 4 -path "*/$*/pm_config" -type d)" && \
	if [[ -d "$$PM" ]]; then \
		echo "Found custom PM configuration."; \
		make -C "$$PM" -j$(shell nproc); \
		mv "$$PM/csu_pm_config.bin" Build/$*/$(UEFI_TARGET)_GCC5/Firmwares/; \
	fi

	export CFG="$(shell find edk2*/Platform/ -mindepth 4 -maxdepth 4 -path "*/$*/spi_flash_config_all.json" -type f)" && \
	export PATH_PACKAGE_TOOL="$(shell realpath "$(PACKAGE_TOOL)")" && \
	if [[ -f "$$CFG" ]]; then \
		echo "Found custom flash config."; \
		cp "$$CFG" Build/$*/$(UEFI_TARGET)_GCC5/; \
	else \
		cp "$$PATH_PACKAGE_TOOL/spi_flash_config_all.json" Build/$*/$(UEFI_TARGET)_GCC5/; \
	fi

	export PATH_PACKAGE_TOOL="$(shell realpath "$(PACKAGE_TOOL)")" && \
	pushd "Build/$*/$(UEFI_TARGET)_GCC5/" && \
	"$$PATH_PACKAGE_TOOL/cix_package_tool" -c "./spi_flash_config_all.json" -o "./cix_flash_all.bin" && \
	popd

Build/%/$(UEFI_TARGET)_GCC5/Firmwares/bootloader3.img: Build/%/$(UEFI_TARGET)_GCC5/FV/SKY1_BL33_UEFI.fd Build/%/$(UEFI_TARGET)_GCC5/Firmwares/dummy.bin
	cp -aR $(PACKAGE_TOOL)/Keys/ $(PACKAGE_TOOL)/certs/ Build/$*/$(UEFI_TARGET)_GCC5/
	export PATH_PACKAGE_TOOL="$(shell realpath "$(PACKAGE_TOOL)")" && \
	"$$PATH_PACKAGE_TOOL/cert_uefi_create_rsa" --key-alg rsa --key-size 3072 --hash-alg sha256 -p --ntfw-nvctr 223 \
		--nt-fw-cert Build/$*/$(UEFI_TARGET)_GCC5/certs/nt_fw_cert.crt \
		--nt-fw-key-cert Build/$*/$(UEFI_TARGET)_GCC5/certs/nt_fw_key.crt \
		--nt-fw-key Build/$*/$(UEFI_TARGET)_GCC5/Keys/oem_privatekey.pem \
		--non-trusted-world-key Build/$*/$(UEFI_TARGET)_GCC5/Keys/oem_privatekey.pem \
		--nt-fw "$(shell realpath "$<")" && \
	"$$PATH_PACKAGE_TOOL/fiptool" create \
		--trusted-key-cert Build/$*/$(UEFI_TARGET)_GCC5/certs/trusted_key_no.crt \
		--nt-fw-key-cert Build/$*/$(UEFI_TARGET)_GCC5/certs/nt_fw_key.crt \
		--nt-fw-cert Build/$*/$(UEFI_TARGET)_GCC5/certs/nt_fw_cert.crt \
		--nt-fw "$(shell realpath "$<")" \
		$@

Build/%/$(UEFI_TARGET)_GCC5/Firmwares/dummy.bin:
	cp -aR $(PACKAGE_TOOL)/Firmwares/ Build/$*/$(UEFI_TARGET)_GCC5/
	# \377 = 0xFF
	head -c 8192 < /dev/zero | tr '\000' '\377' > $@

	export FW="$(shell find edk2*/Platform/ -mindepth 4 -maxdepth 4 -path "*/$*/Firmwares" -type d)" && \
	if [[ -d "$$FW" ]]; then \
		echo "Found custom firmware."; \
		cp -r "$$FW/." Build/$*/$(UEFI_TARGET)_GCC5/Firmwares/; \
		if [[ ! -f "$$FW/ec_fw.bin" ]]; then \
			ln -sf dummy.bin Build/$*/$(UEFI_TARGET)_GCC5/Firmwares/ec_fw.bin; \
		fi; \
	fi

.ONESHELL:
SHELL := bash
Build/%/$(UEFI_TARGET)_GCC5/FV/SKY1_BL33_UEFI.fd:
	make -C edk2/BaseTools -j$(shell nproc) Source/C
	export WORKSPACE="$(shell pwd)"
	export PACKAGES_PATH="$$WORKSPACE/edk2:$$WORKSPACE/edk2-platforms:$$WORKSPACE/edk2-non-osi"
	export GCC5_AARCH64_PREFIX="/opt/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/bin/aarch64-none-elf-"
	if [[ -f tools/acpica/generate/unix/bin/iasl ]]; then
		export IASL_PREFIX="$$WORKSPACE/tools/acpica/generate/unix/bin/"
	fi
	unset MAKEFLAGS
	source edk2/edksetup.sh --reconfig
	build -a AARCH64 -t GCC5 -p "$(subst edk2-platforms/,,$(filter %/$*.dsc,$(DSC)))" \
		-b $(UEFI_TARGET) -D BOARD_NAME=$(word 2, $(subst /,, $@)) -D BUILD_DATE=$(shell date -Is) \
		-D SMP_ENABLE=1 -D ACPI_BOOT_ENABLE=1 -D FASTBOOT_LOAD= -D VARIABLE_TYPE=SPI -D STANDARD_MM=TRUE \
		-D COMMIT_HASH=$(shell git rev-parse --short HEAD) \
		-D EDK2_COMMIT_HASH=$(shell cd edk2 && git rev-parse --short HEAD) \
		-D EDK2_NON_OSI_COMMIT_HASH=$(shell cd edk2-non-osi && git rev-parse --short HEAD) \
		-D EDK2_PLATFORMS_COMMIT_HASH=$(shell cd edk2-platforms && git rev-parse --short HEAD) \
		-D DEB_VERSION=$(shell cd .. && dpkg-parsechangelog -S Version)

tools/acpica/generate/unix/bin/iasl:
	make -C tools/acpica -j$(shell nproc)

.PHONY: clean
clean:
	rm -rf Build
	make -C edk2/BaseTools -j$(shell nproc) clean
	make -C tools/acpica -j$(shell nproc) veryclean || true

.PHONY: distclean
distclean: clean
