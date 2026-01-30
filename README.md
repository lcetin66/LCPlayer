# LCPlayer — Premium tvOS Video Player SDK

LCPlayer, tvOS uygulamaları için tasarlanmış modern, premium ve geliştirici dostu bir video oynatıcı SDK’sıdır.  
IPTV Player geliştiricileri kendi uygulamalarına kolayca entegre edebilir.

- AVPlayer tabanlı güçlü playback engine  
- Premium overlay (top bar, timeline, buffer bar)  
- Audio & Subtitle track selection panel  
- Siri Remote desteği  
- Tema & özelleştirme  
- Configuration & Delegate  
- Swift Package olarak dağıtım  

---

## Kurulum

### Swift Package Manager

Xcode → **File → Add Packages…**

Aşağıdaki URL’yi ekleyin:

https://github.com/lcetin66/LCPlayer.git


veya `Package.swift` içine:

```swift
.package(url: "https://github.com/lcetin66/LCPlayer.git", from: "1.0.0")

Temel Kullanım

import LCPlayer

let url = URL(string: "https://example.com/stream.m3u8")!

let player = LCPlayerViewController(
    stream: url,
    title: "My Channel"
)

present(player, animated: true)

LCPlayer otomatik olarak:
• overlay’i gösterir
• timeline + buffer bar çalışır
• audio/subtitle track’leri algılar
• remote kontrolleri aktif eder

Configuration
Geliştiriciler player davranışını özelleştirebilir:

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

Tema ile:
• overlay renkleri
• timeline renkleri
• buffer bar
• yazı renkleri
özelleştirilebilir.

Delegate
Player event’lerini dinlemek için:

class MyController: UIViewController, LCPlayerDelegate {

    func lcplayerDidStartPlaying() { }
    func lcplayerDidPause() { }
    func lcplayerDidFail(error: Error) { }
    func lcplayerDidChangeAudioTrack(index: Int) { }
    func lcplayerDidChangeSubtitleTrack(index: Int?) { }
}

Kullanım:
let player = LCPlayerViewController(stream: url)
player.delegate = self

Audio & Subtitle Track Panel
Siri Remote down tuşu ile açılır.
• Audio track listesi
• Subtitle track listesi
• “None” seçeneği
• tvOS Focus Engine uyumlu
• Anında uygulama
Geliştiricinin ekstra bir şey yapmasına gerek yok.
---
Siri Remote Desteği
• Select → overlay aç/kapa
• Play/Pause → oynat/durdur
• Down → track panel aç
• Menu → track panel kapat
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


