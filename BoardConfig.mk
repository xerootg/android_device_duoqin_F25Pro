#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/duoqin/F25Pro

BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_PREBUILT_ELF_FILES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a75

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

# Bootloader
BOARD_VENDOR := duoqin
TARGET_BOOTLOADER_BOARD_NAME := F22Pro
TARGET_NO_BOOTLOADER := true

# Boot image: header v4, recovery-in-vendor_boot (stock layout).
# Values verified on-device by the TWRP port (device_qin_F25Pro-TWRP).
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_RAMDISK_OFFSET := 0x07c08000
BOARD_KERNEL_TAGS_OFFSET := 0x0bc08000
BOARD_DTB_OFFSET := 0x0bc08000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_RAMDISK_USE_LZ4 := true

BOARD_MKBOOTIMG_ARGS := --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# Kernel: built from source (GKI android12-5.10, exact stock tag).
# gki_defconfig + device fragment merged by the lineage kernel build.
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/duoqin/F25Pro
TARGET_KERNEL_CONFIG := mssi_64_cn_defconfig
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_KERNEL_CLANG_COMPILE := true
# ACK android12-5.10 has no scripts/Makefile.clang - clang's --target
# is derived from CROSS_COMPILE only. Lineage defaults 5.10+ to
# NO_GCC=true (no CROSS_COMPILE passed), which makes clang compile for
# the x86 host ("unknown register name 'x0'"). Force the GCC-prefixed
# cross-compile environment back on.
TARGET_KERNEL_NO_GCC := false

# Build the kernel with the exact clang it shipped with (clang 12,
# r416183b - same CONFIG_CC_VERSION_TEXT as stock, ABI-verified).
# Newer clang (r487747c/17) breaks the 5.10 stack-protector probes
# (undefined __stack_chk_guard at vmlinux link). NOTE: r416183b is not
# in the LineageOS prebuilts manifest - symlink it into the workspace:
#   ln -s <kernel-workspace>/prebuilts-master/clang/host/linux-x86/clang-r416183b \
#     prebuilts/clang/host/linux-x86/clang-r416183b
TARGET_KERNEL_CLANG_VERSION := r416183b

# DTB: prebuilt from stock vendor_boot (GKI common has no MTK dts).
# With header v4 the build places the dtb into vendor_boot, matching
# the stock layout - the flag must still be true for the build system.
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# DTBO: stock image, reflashed as-is (panel/touch selection lives here)
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img

# First-stage kernel modules (stock vendor_boot set, KMI-compatible
# with our built kernel - verified 0 CRC mismatches vs stock).
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := \
    $(wildcard $(DEVICE_PATH)/prebuilt/first-stage-modules/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := \
    $(strip $(foreach m,$(shell cat $(DEVICE_PATH)/prebuilt/first-stage-modules/modules.load),$(m)))

# A/B (virtual). Slot B is factory-empty on this device - the bootctrl
# HAL in bootctrl/ is patched to fail before touching misc.
AB_OTA_UPDATER := true
BOARD_USES_RECOVERY_AS_BOOT :=
TARGET_NO_RECOVERY := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    dtbo \
    system \
    system_ext \
    product \
    vendor \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor

# Partitions (geometry from stock; verified by TWRP port)
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_SUPER_PARTITION_SIZE := 8589934592
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_PARTITION_LIST := system system_ext vendor product
BOARD_MAIN_SIZE := 8585740288
BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext

# Verified Boot (test keys until release signing)
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 2

# Platform
TARGET_BOARD_PLATFORM := mt6768
BOARD_HAS_MTK_HARDWARE := true
BOARD_USES_MTK_HARDWARE := true

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery (LineageOS recovery goes into vendor_boot; in practice TWRP
# from device_qin_F25Pro-TWRP owns the vendor_boot partition)
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6768
TARGET_USERIMAGES_USE_MKE2FS := true

# Security patch level: track the stock vendor
VENDOR_SECURITY_PATCH := 2025-10-05

# SELinux. We ship the stock prebuilt vendor policy (vendor/etc/selinux
# blobs) rather than building vendor policy from source; the treble
# sepolicy compat tests can't run against that arrangement (missing
# generated plat mapping targets), so skip them for bring-up.
# TODO: build vendor policy from source and drop this.
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SELINUX_IGNORE_NEVERALLOWS := true

# VINTF: base manifest only. The stock per-HAL fragments are installed
# standalone to /vendor/etc/vintf/manifest/ by the vendor tree's
# proprietary-files.txt (the sanctioned prebuilt path), and checkvintf
# reads them at runtime alongside this manifest. The two sets are
# disjoint - merging the fragments in here as well double-declares each
# HAL and fails checkvintf with a duplicate-FqInstance conflict.
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/compatibility_matrix.xml
# Declare the stock MTK vendor/proprietary HALs (radio ext, aee, log,
# mtkpower, pq, ...) as optional framework requirements so check_vintf
# accepts the device manifest - AOSP's framework matrices don't list them.
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DEVICE_PATH)/framework_compatibility_matrix.xml

# Vendor blobs
include vendor/duoqin/F25Pro/BoardConfigVendor.mk
