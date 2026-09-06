# LineageOS device tree for DuoQin Qin F25 Pro (F25Pro)

Device configuration for the DuoQin Qin F25 Pro keypad phone
(`mssi_64_cn` / board `AGN_4313R_RD_MX12832_69U`).

| | |
|---|---|
| SoC | MediaTek MT8786 (driver/DT namespace `mt6768`), 2×A75 + 6×A55 |
| GPU | Mali-G52 MC2 |
| Display | 3.5" 640×960 MIPI-DSI (Sitronix ST7703; dual-sourced yuxing/yihua panels, both supported) |
| Kernel | GKI android12-5.10.209, built from source ([linux-duoqin-f25pro](https://github.com/xerootg/linux-duoqin-f25pro)) |
| Vendor | VNDK 31 (stock Android 12-era vendor under an Android 14 system) |
| Boot | Header v4, recovery-in-vendor_boot, A/B (slot B factory-empty — never activate it) |

## Companion repos

- Kernel: [xerootg/linux-duoqin-f25pro](https://github.com/xerootg/linux-duoqin-f25pro) — manifest path `kernel/duoqin/F25Pro`
- Vendor blobs: [xerootg/android_vendor_duoqin_F25Pro](https://github.com/xerootg/android_vendor_duoqin_F25Pro) — manifest path `vendor/duoqin/F25Pro`
- TWRP (separate, device-verified): [xerootg/device_qin_F25Pro-TWRP](https://github.com/xerootg/device_qin_F25Pro-TWRP) — owns the vendor_boot partition in practice

## Status

**First full build succeeds.** `lineage_F25Pro-ap2a-userdebug` produces a
complete image set (boot/dtbo/vendor_boot/system/system_ext/product/vendor
/vbmeta*), with `boot.img` carrying our from-scratch GKI kernel
(`5.10.209`, clang r416183b, built from `kernel/duoqin/F25Pro`) and
check_vintf passing. Not yet flashed/booted on device (Stage 4).

### Earlier Boot-image geometry, partition layout, A/B
slot-B hazard handling, and first-stage module set are ported from the
device-verified TWRP tree. Hardware inventory and evidence:
[HARDWARE.md in the kernel repo](https://github.com/xerootg/linux-duoqin-f25pro/blob/main/HARDWARE.md).

`proprietary-refs/` holds unmodified stock reference files (fstab,
VINTF, vendor build.prop) used to derive the curated versions in this
tree — kept for provenance, not consumed by the build.

## Required workspace patches

DumberOS's `vendor/lineage` fork strips the kernel headers_install command
from `generated_kernel_includes` (GSIs never build kernels). A per-device
build needs it back:

```
git -C vendor/lineage apply device/duoqin/F25Pro/patches/vendor-lineage-restore-kernel-headers-cmd.patch
git -C vendor/interfaces apply device/duoqin/F25Pro/patches/vendor-interfaces-mtkpower-callback-src.patch
git -C frameworks/base apply device/duoqin/F25Pro/patches/frameworks-base-certhack-hide-placement.patch
git -C build/soong apply device/duoqin/F25Pro/patches/soong-bootjars-allow-samsung-radio.patch
```

Also symlink the stock kernel toolchain (see BoardConfig.mk comments):

```
ln -s <linux-duoqin-f25pro>/prebuilts-master/clang/host/linux-x86/clang-r416183b \
  prebuilts/clang/host/linux-x86/clang-r416183b
```

## Build flags

DumberOS's frameworks/base adds keystore2 classes not present in the
checked-in API signature files, so build with stub validation off
(build-time API tracking only, no effect on the images):

```
DISABLE_STUB_VALIDATION=true m
```
