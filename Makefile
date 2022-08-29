TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = MobileSMS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SMSStats

SMSStats_FILES = Tweak.x SSViewController/SSViewController.m SSDBManager/SSDBManager.m
SMSStats_LIBRARIES = sqlite3
SMSStats_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
