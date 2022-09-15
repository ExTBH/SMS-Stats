TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = MobileSMS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SMSStats3

SMSStats3_FILES = GlobalStats.x SingleStats.x SSViewController/SSViewController.m SSDBManager/SSDBManager.m
SMSStats3_LIBRARIES = sqlite3
SMSStats3_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
