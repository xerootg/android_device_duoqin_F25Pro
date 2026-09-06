#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from F25Pro device
$(call inherit-product, device/duoqin/F25Pro/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_DEVICE := F25Pro
PRODUCT_NAME := lineage_F25Pro
PRODUCT_BRAND := Qin
PRODUCT_MODEL := Qin F25 Pro
PRODUCT_MANUFACTURER := DuoQin

PRODUCT_GMS_CLIENTID_BASE := android-duoqin

# Keep the stock fingerprint so vendor-side version checks stay happy
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sys_mssi_64_cn-user 14 UP1A.231005.007 89 release-keys" \
    BuildFingerprint=Qin/sys_mssi_64_cn/mssi_64_cn:14/UP1A.231005.007/89:user/release-keys \
    DeviceProduct=sys_mssi_64_cn
