# KidsVideo iOS App

KidsVideo is an iOS video player application for children built with SwiftUI and Core Data. The app features AirPlay streaming, video collection management, and custom UI themes. It includes Japanese content and uses the Skip framework for potential cross-platform development.

**ALWAYS follow these instructions first and only search for additional information if these instructions are incomplete or found to be in error.**

## Platform Requirements

**CRITICAL: This project requires macOS with Xcode installed. It CANNOT be built on Linux or Windows.**

- macOS 12.0 or later
- Xcode 14.0 or later (supports iOS 15.0+ deployment target)
- iOS Simulator or physical iOS device for testing
- Internet connection for Skip framework dependencies

## Working Effectively

### Initial Setup
```bash
# Ensure Xcode command line tools are installed
xcode-select --install

# Clone and navigate to repository
cd /path/to/KidsVideo

# Open project in Xcode
open KidsVideo.xcodeproj
```

### Build Process
**NEVER CANCEL builds - they may take 15-30 minutes on first run due to Skip framework dependencies**

```bash
# Clean build folder (when needed)
xcodebuild clean -project KidsVideo.xcodeproj -scheme "KidsVideo (iOS)"

# Build for iOS Simulator - NEVER CANCEL: Takes 15-30 minutes. Set timeout to 45+ minutes.
xcodebuild build -project KidsVideo.xcodeproj -scheme "KidsVideo (iOS)" -destination "platform=iOS Simulator,name=iPhone 15,OS=latest"

# Build for iOS Device (requires valid provisioning profile)
xcodebuild build -project KidsVideo.xcodeproj -scheme "KidsVideo (iOS)" -destination "generic/platform=iOS"
```

### Testing
**NEVER CANCEL tests - UI tests may take 10-15 minutes to complete**

```bash
# Run UI tests - NEVER CANCEL: Takes 10-15 minutes. Set timeout to 25+ minutes.
xcodebuild test -project KidsVideo.xcodeproj -scheme "KidsVideo (iOS)" -destination "platform=iOS Simulator,name=iPhone 15,OS=latest"

# Run tests in Xcode IDE: Use Test Navigator (⌘6) then click Run Tests
```

### Running the App

**iOS Simulator:**
```bash
# Build and run in simulator
xcodebuild build -project KidsVideo.xcodeproj -scheme "KidsVideo (iOS)" -destination "platform=iOS Simulator,name=iPhone 15,OS=latest"
# Then launch from Xcode or use xcrun simctl
```

**Physical Device:**
- Requires Apple Developer account for code signing
- Configure development team in Xcode project settings
- Connect iOS device and select as run destination

### Video Content Management
```bash
# Process video metadata (requires mediainfo)
brew install mediainfo
./createContentsStrings.sh

# Script processes MP4 files in Shared/Resources/Movie/ and generates Content entries
# Output is copied to clipboard for manual insertion into code
```

## Validation

### Mandatory Testing Scenarios
**ALWAYS run these validation steps after making changes:**

1. **App Launch Test:**
   - Launch app in iOS Simulator
   - Verify main ContentView loads without crashes
   - Check video collection appears with thumbnails

2. **Video Playback Test:**
   - Select a video from the collection
   - Verify SummerPlayerView opens correctly
   - Test play/pause functionality
   - Verify video controls respond properly

3. **AirPlay Functionality Test:**
   - Ensure test device is on same Wi-Fi network as AirPlay device
   - Open video player
   - Tap AirPlay button (top-right)
   - Verify AirPlay device list appears
   - Test connection to AirPlay device

4. **Memory Management Test:**
   - Navigate between multiple videos
   - Trigger memory warning in Simulator (Device → Memory Warning)
   - Verify app doesn't crash and thumbnails reload properly

5. **Background/Foreground Test:**
   - Start video playback
   - Background the app (⌘⇧H in Simulator)
   - Return to foreground
   - Verify playback state is preserved

### Build Validation
**ALWAYS run before committing changes:**
```bash
# Verify project builds successfully
xcodebuild build -project KidsVideo.xcodeproj -scheme "KidsVideo (iOS)" -destination "platform=iOS Simulator,name=iPhone 15,OS=latest"

# Run static analysis
xcodebuild analyze -project KidsVideo.xcodeproj -scheme "KidsVideo (iOS)"
```

## Timing Expectations

**Set these timeout values - NEVER CANCEL early:**
- **Initial build with dependencies**: 15-30 minutes (set 45+ minute timeout)
- **Incremental builds**: 2-5 minutes (set 10+ minute timeout)
- **UI test suite**: 10-15 minutes (set 25+ minute timeout)
- **App launch**: 5-10 seconds
- **Video thumbnail generation**: 1-3 seconds per video

## Common Tasks

### Adding New Video Content
1. Place MP4 files in `Shared/Resources/Movie/[category]/` directory
2. Run `./createContentsStrings.sh` to generate Content entries with metadata
3. Copy generated output (automatically placed in clipboard) 
4. Edit `Shared/Models/Contents/ContentsMaker.swift` and add new Content entries to the contents array:
   ```swift
   Content(fileName: "video_name", fileExt: "mp4", totalTime: "12:34", channel: .channelName)
   ```
5. Add corresponding thumbnail JPEG images to `Shared/Resources/` (named to match channel)
6. Update Channel enum in relevant model files if adding new channel categories

### Modifying UI Components
- **PlayerControlView**: Video player controls and AirPlay button
- **ContentListView**: Video collection grid
- **SummerPlayerView**: Main video player interface
- **VideoCollectionViewCell**: Individual video thumbnails

### Core Data Model Changes
1. Modify `KidsVideo.xcdatamodeld`
2. Generate new NSManagedObject subclasses if needed
3. Update PersistenceController if migration required
4. Test with fresh app install

### Troubleshooting AirPlay Issues
- Check Info.plist contains NSBonjourServices array with `_airplay._tcp` and `_raop._tcp`
- Verify devices are on same Wi-Fi network
- Test with iOS device (AirPlay doesn't work reliably in Simulator)
- Check iOS target deployment (requires iOS 11.0+)

## Project Structure Reference

```
KidsVideo/
├── KidsVideo.xcodeproj/          # Xcode project file
├── Shared/                       # Main app source code
│   ├── KidsVideoApp.swift       # App entry point
│   ├── Views/                   # SwiftUI views
│   │   ├── Menu/ContentView.swift
│   │   ├── SummerPlayerView.swift
│   │   ├── ContentListView.swift
│   │   └── PlayerControlView.swift
│   ├── Models/                  # Data models and utilities
│   ├── Controllers/             # View controllers
│   ├── Resources/               # Assets, fonts, videos
│   └── KidsVideo.xcdatamodeld/ # Core Data model
├── Tests_iOS/                   # UI test target
├── createContentsStrings.sh     # Video metadata processing
└── AirPlay_Implementation_Guide.md
```

## Dependencies

**External Dependencies:**
- Skip framework (https://source.skip.tools/skip.git) - Requires internet access
- System frameworks: SwiftUI, UIKit, AVFoundation, AVKit, Core Data

**Build Tools:**
- mediainfo (for video processing script): `brew install mediainfo`

## Limitations and Known Issues

1. **Platform**: iOS only - no macOS or other platform support
2. **AirPlay**: Requires physical iOS device for full testing
3. **Network**: Skip framework requires internet access during initial build
4. **Signing**: Requires Apple Developer account for device deployment
5. **Content**: Japanese video content may require specific font support

## Development Workflow

1. **Before Making Changes:**
   - Build project to ensure clean starting state
   - Run UI tests to verify current functionality

2. **During Development:**
   - Use Xcode for interactive development and debugging
   - Test frequently in iOS Simulator
   - Use Xcode's memory debugger for performance issues

3. **Before Committing:**
   - Build successfully with no warnings
   - Run UI test suite
   - Test on physical device if AirPlay changes were made
   - Validate new video content with createContentsStrings.sh if applicable

## Common Command Outputs

### Repository Root Structure
```
ls -la
total 56
drwxr-xr-x 6 runner docker 4096 Aug 10 08:32  .
drwxr-xr-x 3 runner docker 4096 Aug 10 08:32  ..
drwxr-xr-x 7 runner docker 4096 Aug 10 08:32  .git
-rw-r--r-- 1 runner docker 2205 Aug 10 08:32  .gitignore
-rw-r--r-- 1 runner docker 4444 Aug 10 08:32  AirPlay_Implementation_Guide.md
-rw-r--r-- 1 runner docker  713 Aug 10 08:32  Font+Extensions.swift
-rw-r--r-- 1 runner docker  607 Aug 10 08:32  KidsVideo--iOS--Info.plist
drwxr-xr-x 4 runner docker 4096 Aug 10 08:32  KidsVideo.xcodeproj
-rw-r--r-- 1 runner docker  250 Aug 10 08:32 'KidsVideo_(iOS).entitlements'
-rw-r--r-- 1 runner docker   11 Aug 10 08:32  README.md
drwxr-xr-x 8 runner docker 4096 Aug 10 08:32  Shared
drwxr-xr-x 2 runner docker 4096 Aug 10 08:32  Tests_iOS
-rwxr-xr-x 1 runner docker 1252 Aug 10 08:32  createContentsStrings.sh
```

### Swift File Count
```bash
find Shared -type f -name "*.swift" | wc -l
# Result: 37 Swift files
```

### Key Files for Common Modifications
- `Shared/Views/Menu/ContentView.swift` - Main app interface
- `Shared/Views/SummerPlayerView.swift` - Video player component
- `Shared/Views/PlayerControlView.swift` - Player controls and AirPlay button
- `Shared/Models/Contents/ContentsMaker.swift` - Video content definitions array
- `Shared/Models/Contents/Content.swift` - Video content model structure
- `Shared/Controllers/PlayerViewController.swift` - Video player controller
- `Shared/KidsVideoApp.swift` - App entry point and lifecycle
- `KidsVideo--iOS--Info.plist` - App configuration and AirPlay permissions

### Important Directories
- `Shared/Resources/Music/` - Background music files  
- `Shared/Resources/Fonts/` - Custom font files
- `Shared/Resources/` - Video thumbnail images
- `Shared/Models/Utills/` - Utility classes and extensions
- `Tests_iOS/` - UI test cases

**Remember: This is an iOS project requiring macOS and Xcode. Building on other platforms will fail.**