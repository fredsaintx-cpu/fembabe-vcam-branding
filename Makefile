# FemBabe branding companion for the existing VCam package.

ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = fembabe_branding
fembabe_branding_FILES = Tweak.xm
fembabe_branding_FRAMEWORKS = UIKit Foundation
fembabe_branding_CFLAGS = -fobjc-arc -O2
fembabe_branding_LDFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
