# LCPlayer — Premium tvOS Video Player SDK

LCPlayer is a modern, premium, and developer-friendly video player SDK designed specifically for tvOS applications.
IPTV player developers can easily integrate it into their own apps.
	•	Powerful playback engine based on AVPlayer
	•	Premium overlay (top bar, timeline, buffer bar)
	•	Audio & subtitle track selection panel
	•	Siri Remote support
	•	Theme & customization
	•	Configuration & Delegate support
	•	Distributed as a Swift Package


---

## Installation

### Swift Package Manager

Xcode → **File → Add Packages…**

Add the following URL:

https://github.com/lcetin66/LCPlayer.git


Or add it to your `Package.swift` :

```swift
.package(url: "https://github.com/lcetin66/LCPlayer.git", from: "1.0.0")

Basic Usage

import LCPlayer

let url = URL(string: "https://example.com/stream.m3u8")!

let player = LCPlayerViewController(
    stream: url,
    title: "My Channel"
)

present(player, animated: true)

LCPlayer automatically:
	•	Displays the overlay
	•	Activates the timeline and buffer bar
	•	Detects audio and subtitle tracks
	•	Enables remote controls

Configuration
Developers can customize player behavior:

let config = LCPlayerConfiguration(
    showsTopBar: true,
    showsBottomBar: true,
    autoHideOverlay: true,
    autoHideInterval: 4.0,
    theme: .default
)

let player = LCPlayerViewController(
    stream: url,
    title: "My Channel",
    configuration: config
)

Tema (LCPlayerTheme)

var theme = LCPlayerTheme.default
theme.primaryColor = .orange
theme.progressColor = .white
theme.textColor = .white

let config = LCPlayerConfiguration(theme: theme)

With theming you can customize:
	•	Overlay colors
	•	Timeline colors
	•	Buffer bar
	•	Text colors

Delegate
To listen to player events:

class MyController: UIViewController, LCPlayerDelegate {

    func lcplayerDidStartPlaying() { }
    func lcplayerDidPause() { }
    func lcplayerDidFail(error: Error) { }
    func lcplayerDidChangeAudioTrack(index: Int) { }
    func lcplayerDidChangeSubtitleTrack(index: Int?) { }
}

Usage:
let player = LCPlayerViewController(stream: url)
player.delegate = self

Audio & Subtitle Track Panel

Opens with the Siri Remote Down button.
	•	Audio track list
	•	Subtitle track list
	•	“None” option
	•	tvOS Focus Engine compatible
	•	Applies changes instantly

No additional implementation is required from the developer.
---
Siri Remote Support
	•	Select → Show/Hide overlay
	•	Play/Pause → Play or pause
	•	Down → Open track panel
	•	Menu → Close track panel
---
Public API
LCPlayerViewController

init(
    stream: URL,
    title: String? = nil,
    configuration: LCPlayerConfiguration = .init()
)

LCPlayerConfiguration

struct LCPlayerConfiguration {
    var showsTopBar: Bool
    var showsBottomBar: Bool
    var autoHideOverlay: Bool
    var autoHideInterval: TimeInterval
    var theme: LCPlayerTheme
}

LCPlayerTheme

struct LCPlayerTheme {
    var primaryColor: UIColor
    var secondaryColor: UIColor
    var overlayBackground: UIColor
    var progressColor: UIColor
    var bufferedColor: UIColor
    var textColor: UIColor
}

LCPlayerDelegate

protocol LCPlayerDelegate: AnyObject {
    func lcplayerDidStartPlaying()
    func lcplayerDidPause()
    func lcplayerDidFail(error: Error)
    func lcplayerDidChangeAudioTrack(index: Int)
    func lcplayerDidChangeSubtitleTrack(index: Int?)
}

Minimum Gereksinimler
• tvOS 15+
• Swift 5.9+
• Xcode 15+

Mimarinin Özeti

LCPlayer
 ├── Core/
 │    ├── LCPlayerConfiguration.swift
 │    ├── LCPlayerTheme.swift
 │    └── LCPlayerDelegate.swift
 ├── Engine/
 │    └── LCPlaybackEngine.swift
 ├── UI/
 │    ├── LCOverlayView.swift
 │    └── LCTrackSelectionView.swift
 └── LCPlayerViewController.swift

Lisans
MIT License
© 2025 LCPlayer Team


