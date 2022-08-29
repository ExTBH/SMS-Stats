TARGET := iphone:clang:latest:7.0


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SMSStats

SMSStats_FILES = Tweak.x
SMSStats_CFLAGS = -fobjc-arc
SMSStats_LIBRARIES = FMDB
include $(THEOS_MAKE_PATH)/tweak.mk
