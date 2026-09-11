#!/bin/bash
set -euo pipefail

PKG=com.fembabe.vcam.branding
VER=1.0.0
ROOT=build/debroot
OUT=packages
DYLIB=.theos/obj/debug/fembabe_branding.dylib

rm -rf "$ROOT"
mkdir -p "$ROOT/DEBIAN" "$ROOT/var/jb/Library/MobileSubstrate/DynamicLibraries" "$OUT"

cat > "$ROOT/DEBIAN/control" <<EOF
Package: $PKG
Name: FemBabe VCam Branding
Description: Cosmetic branding companion for FemBabe VCam
Maintainer: FemBabe
Author: FemBabe
Section: Tweaks
Architecture: iphoneos-arm64
Version: $VER
Depends: com.fembabe.vcam (>= 0.0.2-52.4)
Installed-Size: 128
EOF

cat > "$ROOT/DEBIAN/postinst" <<'EOF'
#!/bin/sh
launchctl submit -l com.fembabe.vcam.branding.respring -p /bin/sh -- -c "sleep 3; sbreload; launchctl bootout system/com.fembabe.vcam.branding.respring" 2>/dev/null || true
exit 0
EOF

cat > "$ROOT/DEBIAN/postrm" <<'EOF'
#!/bin/sh
if [ "$1" = "remove" ] || [ "$1" = "purge" ]; then
  launchctl submit -l com.fembabe.vcam.branding.respring -p /bin/sh -- -c "sleep 3; sbreload; launchctl bootout system/com.fembabe.vcam.branding.respring" 2>/dev/null || true
fi
exit 0
EOF

cp "$DYLIB" "$ROOT/var/jb/Library/MobileSubstrate/DynamicLibraries/fembabe_branding.dylib"
cp fembabe_branding.plist "$ROOT/var/jb/Library/MobileSubstrate/DynamicLibraries/fembabe_branding.plist"

chmod 755 "$ROOT/DEBIAN" "$ROOT/DEBIAN/postinst" "$ROOT/DEBIAN/postrm"
chmod 644 "$ROOT/DEBIAN/control" "$ROOT/var/jb/Library/MobileSubstrate/DynamicLibraries/fembabe_branding.plist"
chmod 755 "$ROOT/var/jb/Library/MobileSubstrate/DynamicLibraries/fembabe_branding.dylib"

dpkg-deb -Zxz -b "$ROOT" "$OUT/${PKG}_${VER}_iphoneos-arm64.deb"
