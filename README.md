# proprietary_vendor_xiaomi_camera

Prebuilt stock MIUI Camera to include in custom ROM builds.

### Supported devices
* POCO F5 / Redmi Note 12 Turbo (Marble)

### How to use?

1. Clone this repo to `vendor/xiaomi/camera`

2. Inherit it from `device.mk` in device tree:

```
# Camera
$(call inherit-product-if-exists, vendor/xiaomi/camera/miuicamera.mk)
```

3. Set `ro.product.mod_device` according to stock, and `ro.miui.notch=1` if the device has a display cutout, for example:

```
PRODUCT_SYSTEM_PROPERTIES += \
    ro.miui.notch=1 \
    ro.product.mod_device=lisa
```
