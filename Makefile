include /framework/makefiles/common.mk

TWEAK_NAME = OS7
OS7_FILES = Tweak.xm
OS7_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
OS7_OBJC_FILES = OS7Tile.m OS7ListApp.m OS7.m

include /framework/makefiles/tweak.mk