#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=camera
DEVICE_COMMON=camera
VENDOR=xiaomi

#export TARGET_ENABLE_CHECKELF=false

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "system" ]; then
        return 1
    fi

    case "$1" in
        vendor.xiaomi.hardware.campostproc@1.0)
            echo "$1_system"
            ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" true

# Warning headers and guards
write_headers "marble"
sed -i 's|device/|vendor/|g' "$ANDROIDBP" "$ANDROIDMK" "$BOARDMK" "$PRODUCTMK"

write_makefiles "${MY_DIR}/proprietary-files.txt"

# Finish
write_footers
