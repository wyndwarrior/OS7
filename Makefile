export ARCHS = armv7 arm64 armv7s
export SOURCE = src
export THEOS = theos
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 5.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OS7
OS7_FILES = $(SOURCE)/Tweak.xm
OS7_FRAMEWORKS = Foundation UIKit CoreGraphics
OS7_OBJC_FILES = $(SOURCE)/OS7Tile.m $(SOURCE)/OS7ListApp.m $(SOURCE)/OS7.m

include $(THEOS)/makefiles/tweak.mk

