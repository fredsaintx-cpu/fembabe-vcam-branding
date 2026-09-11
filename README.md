# FemBabe VCam Branding

Cosmetic branding companion for the rootless FemBabe VCam package.

This tweak changes the existing SpringBoard overlay without replacing the
camera engine, daemons, networking, TLS pinning, or licensing code:

- Changes the floating badge title from `UF` to `FB`.
- Uses a dark purple badge background.
- Changes exact `UFATM APP` title prefixes to `FemBabeCam`.

## Requirements

- Rootless jailbreak with ElleKit
- `com.fembabe.vcam`
- iOS 15 or later

## Build

The GitHub Actions workflow builds arm64 and arm64e slices with Theos and
packages the result using `dpkg-deb -Zxz`.

Run the **Build FemBabe VCam Branding** workflow, then download the
`fembabe-vcam-branding` artifact.

## Package

Package identifier: `com.fembabe.vcam.branding`

The companion can be installed and removed independently of the main VCam
package.
