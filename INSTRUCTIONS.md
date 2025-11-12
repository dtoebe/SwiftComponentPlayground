# iOS Device Deployment Guide

Complete guide for deploying iOS apps to physical devices and simulators using command-line tools.

## Device Management

### List Simulators

**List all available devices:**
```shell
xcrun simctl list devices
```

**List only available devices:**
```shell
xcrun simctl list devices available
```

**Filter for iPhone simulators:**
```shell
xcrun simctl list devices available | grep iPhone
```

### List Physical Devices

**List all devices (physical + simulators):**
```shell
xcrun xctrace list devices
```

**List only physical devices:**
```shell
xcrun xctrace list devices | grep -v Simulator
```

**Alternative method:**
```shell
instruments -s devices | grep -v Simulator
```

**Get device UDID:**
```shell
xcrun xctrace list devices | grep "iPhone"
# Look for the ID in parentheses: (00008140-000164D10193801C)
```

## Setup Requirements

### One-Time Setup

#### 1. Add Apple ID to Xcode

Required for physical device deployment.

- Open Xcode: `open -a Xcode`
- Go to **Xcode → Settings** (or press `Cmd+,`)
- Click **Accounts** tab
- Click **+** → **Apple ID**
- Sign in with your Apple Developer account
- Close Xcode

#### 2. Get Your Team ID

**Option 1: Apple Developer Portal**
- Go to: https://developer.apple.com/account
- Sign in
- Your Team ID is shown in the Membership section

**Option 2: App Store Connect**
- Go to: https://appstoreconnect.apple.com/access/users
- Click your Apple Account Name
- Team ID is displayed (e.g., `EMBMMC3VGP`)

#### 3. Update project.yml

```yaml
settings:
  DEVELOPMENT_TEAM: "EMBMMC3VGP"  # Your Team ID here
  CODE_SIGN_STYLE: Automatic
  SUPPORTED_PLATFORMS: "iphoneos iphonesimulator"
```

#### 4. Regenerate Project

```shell
xcodegen generate
```

## Using watch_and_reload.sh

### Configuration

Edit the top of `watch_and_reload.sh`:

**For Physical Device:**
```bash
DEVICE_ID="00008140-000164D10193801C"  # Your iPhone UDID
PLATFORM="iOS"
```

**For Simulator:**
```bash
DEVICE_ID="A653B8E9-4E0A-45BF-B43F-C475571436D0"  # Simulator ID
PLATFORM="iOS Simulator"
```

### Run the Script

```shell
./watch_and_reload.sh
```

**The script automatically:**
- Builds the app
- Installs on device/simulator
- Launches the app
- Watches for Swift file changes
- Rebuilds and reloads on changes

**Exit:** Press `Ctrl+C`

## Manual Device Deployment

### Build for Device

```shell
xcodebuild -project WhyNotTry.xcodeproj \
  -scheme WhyNotTry \
  -destination 'platform=iOS,id=00008140-000164D10193801C' \
  -derivedDataPath ./build \
  -allowProvisioningUpdates \
  build
```

### Install on Device

```shell
xcrun devicectl device install app \
  --device 00008140-000164D10193801C \
  ./build/Build/Products/Debug-iphoneos/WhyNotTry.app
```

### Launch on Device

```shell
xcrun devicectl device process launch \
  --device 00008140-000164D10193801C \
  com.dtoebe.WhyNotTry
```

## Manual Simulator Deployment

### Build for Simulator

```shell
xcodebuild -project WhyNotTry.xcodeproj \
  -scheme WhyNotTry \
  -destination 'platform=iOS Simulator,id=A653B8E9-4E0A-45BF-B43F-C475571436D0' \
  -derivedDataPath ./build \
  build
```

### Boot Simulator

```shell
# Boot specific simulator
xcrun simctl boot A653B8E9-4E0A-45BF-B43F-C475571436D0

# Open Simulator app
open -a Simulator
```

### Install on Simulator

```shell
xcrun simctl install booted ./build/Build/Products/Debug-iphonesimulator/WhyNotTry.app
```

### Launch on Simulator

```shell
xcrun simctl launch booted com.dtoebe.WhyNotTry
```

### Terminate App on Simulator

```shell
xcrun simctl terminate booted com.dtoebe.WhyNotTry
```

## Troubleshooting

### "No Account for Team" Error

**Problem:** Xcode cannot find the Team ID specified in project.yml

**Solution:**
- Add your Apple ID to Xcode (see One-Time Setup)
- Verify Team ID matches your Apple Developer account
- Check Team ID at https://developer.apple.com/account

### "#Preview conflicts with @main" Error

**Problem:** Swift `#Preview` macro creates top-level code that conflicts with `@main`

**Solution:**
Remove `#Preview` macro from Swift files and use `PreviewProvider` instead:

```swift
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
```

### Device Not Found

**Problem:** Command-line tools cannot detect your device

**Solution:**
- Check device is connected: `xcrun xctrace list devices`
- Verify device UDID in script matches your device
- Enable Developer Mode on iOS 16+ (Settings → Privacy & Security → Developer Mode)
- Trust this computer on your device when prompted

### Signing Errors

**Problem:** Code signing fails during build

**Solution:**
- Verify correct Team ID in `project.yml`
- Regenerate project: `xcodegen generate`
- Check Apple ID is signed in to Xcode
- Ensure device is registered in your Apple Developer account

### Build Fails with "Supported platforms is empty"

**Problem:** Project configuration doesn't specify iOS platform

**Solution:**
Add to your `project.yml`:
```yaml
settings:
  SUPPORTED_PLATFORMS: "iphoneos iphonesimulator"
```

Then regenerate: `xcodegen generate`

### Watch Script Not Detecting Changes

**Problem:** File changes don't trigger rebuild

**Solution:**
- Verify you're using Zsh (not Bash): `echo $SHELL`
- Check file is in `WhyNotTry/` directory
- Ensure file has `.swift` extension
- Exit and restart the watch script

## File Locations

- **Simulator builds:** `./build/Build/Products/Debug-iphonesimulator/`
- **Device builds:** `./build/Build/Products/Debug-iphoneos/`
- **File checksums:** `.file_checksums` (auto-generated by watch script)
- **Xcode project:** `WhyNotTry.xcodeproj` (generated by xcodegen)

## Quick Reference Commands

### Device Management
```shell
# List all devices
xcrun xctrace list devices

# Get specific device UDID
xcrun xctrace list devices | grep "iPhone 16"
```

### Build
```shell
# Device
xcodebuild -project WhyNotTry.xcodeproj -scheme WhyNotTry \
  -destination 'platform=iOS,id=DEVICE_UDID' -derivedDataPath ./build build

# Simulator
xcodebuild -project WhyNotTry.xcodeproj -scheme WhyNotTry \
  -destination 'platform=iOS Simulator,id=SIMULATOR_ID' -derivedDataPath ./build build
```

### Deploy
```shell
# Device
xcrun devicectl device install app --device DEVICE_UDID ./build/Build/Products/Debug-iphoneos/WhyNotTry.app
xcrun devicectl device process launch --device DEVICE_UDID com.dtoebe.WhyNotTry

# Simulator
xcrun simctl install booted ./build/Build/Products/Debug-iphonesimulator/WhyNotTry.app
xcrun simctl launch booted com.dtoebe.WhyNotTry
```

## Best Practices

1. **Use Device UDIDs** instead of device names for reliability in scripts
2. **Keep Team ID in version control** (project.yml) for consistency
3. **Run watch script** for development workflow (auto-rebuild on changes)
4. **Test on physical device** regularly, not just simulator
5. **Enable Developer Mode** on iOS devices for faster deployment
6. **Keep Xcode updated** for latest device support

## Additional Resources

- [Apple Developer Portal](https://developer.apple.com/account)
- [Xcode Command Line Tools Documentation](https://developer.apple.com/library/archive/technotes/tn2339/)
- [XcodeGen Documentation](https://github.com/yonaskolb/XcodeGen)
