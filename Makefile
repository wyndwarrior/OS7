include /framework/makefiles/common.mk

TWEAK_NAME = OS7
OS7_FILES = Tweak.xm
OS7_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
OS7_OBJC_FILES = Tile.m ApplicationListItem.m OS7ViewController.m

include /framework/makefiles/tweak.mk