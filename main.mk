# Copyright (C) 2013-2017 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Include vendor YAOSP
include vendor/yaosp/configs/yaosp_main.mk

export VENDOR := pa

# Include versioning information
# Format: Major.minor.maintenance(-TAG)
export PA_VERSION := 7.2.3-DEV

export ROM_VERSION := $(PA_VERSION)-$(shell date +%Y%m%d-%H%M%S)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=$(ROM_VERSION) \
    ro.pa.version=$(PA_VERSION)

# Override undesired Google defaults
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.setupwizard.require_network=any \
    ro.setupwizard.mode=OPTIONAL \
    ro.opa.eligible_device=true

# Override old AOSP default sounds with newer Google stock ones
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.alarm_alert=Osmium.ogg \
    ro.config.notification_sound=Ariel.ogg \
    ro.config.ringtone=Titania.ogg

# Enable SIP+VoIP
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't Hide APNs
PRODUCT_PROPERTY_OVERRIDES += persist.sys.hideapn=false

# Include vendor overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/pa/overlay/common

# Recommend using the non debug dexpreopter
USE_DEX2OAT_DEBUG := false

# Include APN information
PRODUCT_COPY_FILES += vendor/pa/prebuilt/etc/apns-conf.xml:system/etc/apns-conf.xml

# Allow tethering without provisioning app
PRODUCT_PROPERTY_OVERRIDES += net.tethering.noprovisioning=true

# Include support for preconfigured permissions
PRODUCT_COPY_FILES += vendor/pa/prebuilt/etc/default-permissions/pa-permissions.xml:system/etc/default-permissions/pa-permissions.xml

# Copy PA specific init file
PRODUCT_COPY_FILES += vendor/pa/prebuilt/root/init.pa.rc:root/init.pa.rc

# Include support for additional filesystems
PRODUCT_PACKAGES += \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Include support for GApps backup
PRODUCT_COPY_FILES += \
    vendor/pa/prebuilt/install/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/pa/prebuilt/install/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/pa/prebuilt/addon.d/50-backuptool.sh:system/addon.d/50-backuptool.sh

# Include PA GApps config
PRODUCT_COPY_FILES += \
    vendor/pa/prebuilt/install/gapps-config.txt:install/gapps-config.txt

# Include hostapd configuration
PRODUCT_COPY_FILES += \
    vendor/pa/prebuilt/etc/hostapd/hostapd_default.conf:system/etc/hostapd/hostapd_default.conf \
    vendor/pa/prebuilt/etc/hostapd/hostapd.deny:system/etc/hostapd/hostapd.deny \
    vendor/pa/prebuilt/etc/hostapd/hostapd.accept:system/etc/hostapd/hostapd.accept

# Build Chromium for Snapdragon (PA Browser)
PRODUCT_PACKAGES += PABrowser

# Build Shuttle Paranoid Android Edition
PRODUCT_PACKAGES += Shuttle

# Build Snapdragon apps
PRODUCT_PACKAGES += \
    SnapdragonGallery

# Build sound recorder
PRODUCT_PACKAGES += SoundRecorder

# Build WallpaperPicker
PRODUCT_PACKAGES += WallpaperPicker

# Build ParanoidPapers
PRODUCT_PACKAGES += ParanoidPapers

# Include the custom PA bootanimation
ifeq ($(TARGET_BOOT_ANIMATION_RES),480)
     PRODUCT_COPY_FILES += vendor/pa/prebuilt/bootanimation/480.zip:system/media/bootanimation.zip
endif
ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
     PRODUCT_COPY_FILES += vendor/pa/prebuilt/bootanimation/720.zip:system/media/bootanimation.zip
endif
ifeq ($(TARGET_BOOT_ANIMATION_RES),1080)
     PRODUCT_COPY_FILES += vendor/pa/prebuilt/bootanimation/1080.zip:system/media/bootanimation.zip
endif
ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
     PRODUCT_COPY_FILES += vendor/pa/prebuilt/bootanimation/1440.zip:system/media/bootanimation.zip
endif
ifeq ($(TARGET_BOOT_ANIMATION_RES),2160)
     PRODUCT_COPY_FILES += vendor/pa/prebuilt/bootanimation/2160.zip:system/media/bootanimation.zip
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifeq ($(TARGET_BUILD_VARIANT),user)
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
else
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=0
endif

# AOSPA services
PRODUCT_PACKAGES += pa-services
PRODUCT_PACKAGES += co.aospa.power.ShutdownAOSPA.xml
PRODUCT_BOOT_JARS += pa-services

# TCP Connection Management
PRODUCT_PACKAGES += tcmiface
PRODUCT_BOOT_JARS += tcmiface

# RCS Service
PRODUCT_PACKAGES += \
    rcscommon \
    rcscommon.xml \
    rcsservice \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

# Bluetooth Audio (A2DP)
PRODUCT_PACKAGES += libbthost_if

# Substratum
PRODUCT_PACKAGES += ThemeInterfacer

# Include vendor SEPolicy changes
include vendor/pa/sepolicy/sepolicy.mk

# Include proprietary header flags if vendor/head exists
-include vendor/head/head-capabilities.mk
