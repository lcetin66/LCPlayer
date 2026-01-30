import UIKit
import AVKit

public final class LCPlayerViewController: UIViewController, LCTrackSelectionViewDelegate {

    private let streamURL: URL
    private let titleText: String?
    private let configuration: LCPlayerConfiguration
    public weak var delegate: LCPlayerDelegate?

    private let engine = LCPlaybackEngine()

    private var playerLayer: AVPlayerLayer?
    private var overlayView = LCOverlayView()
    private var overlayVisible = true
    private var overlayTimer: Timer?

    private var trackPanel = LCTrackSelectionView()
    private var trackPanelVisible = false

    public init(
        stream: URL,
        title: String? = nil,
        configuration: LCPlayerConfiguration = .init()
    ) {
        self.streamURL = stream
        self.titleText = title
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPlayer()
        setupOverlay()
        setupTrackPanel()
        setupRemoteCommands()
        startTimeObservation()
        updateTrackInfo()
    }

    private func setupPlayer() {
        engine.load(url: streamURL)

        guard let player = engine.player else { return }

        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspect
        view.layer.addSublayer(layer)
        self.playerLayer = layer

        delegate?.lcplayerDidStartPlaying()
    }

    private func setupOverlay() {
        overlayView.frame = view.bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.applyTheme(configuration.theme)
        view.addSubview(overlayView)

        if let titleText {
            overlayView.setTitle(titleText)
        }

        if !configuration.showsTopBar {
            overlayView.hideTopBar()
        }

        if !configuration.showsBottomBar {
            overlayView.hideBottomBar()
        }

        if configuration.autoHideOverlay {
            startOverlayAutoHideTimer()
        }
    }

    private func setupTrackPanel() {
        trackPanel.frame = view.bounds
        trackPanel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        trackPanel.delegate = self
        view.addSubview(trackPanel)
    }

    // MARK: - Remote Control

    private func setupRemoteCommands() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        view.addGestureRecognizer(tap)

        let playPause = UITapGestureRecognizer(target: self, action: #selector(handlePlayPause))
        playPause.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        view.addGestureRecognizer(playPause)

        let down = UITapGestureRecognizer(target: self, action: #selector(handleDown))
        down.allowedPressTypes = [NSNumber(value: UIPress.PressType.downArrow.rawValue)]
        view.addGestureRecognizer(down)

        let menu = UITapGestureRecognizer(target: self, action: #selector(handleMenu))
        menu.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        view.addGestureRecognizer(menu)
    }

    @objc private func handleTap() {
        if trackPanelVisible {
            hideTrackPanel()
        } else {
            toggleOverlay()
        }
    }

    @objc private func handlePlayPause() {
        switch engine.state {
        case .playing:
            engine.pause()
            delegate?.lcplayerDidPause()
        case .paused:
            engine.play()
            delegate?.lcplayerDidStartPlaying()
        default:
            break
        }
    }

    @objc private func handleDown() {
        showTrackPanel()
    }

    @objc private func handleMenu() {
        if trackPanelVisible {
            hideTrackPanel()
        }
    }

    private func toggleOverlay() {
        overlayVisible.toggle()

        UIView.animate(withDuration: 0.25) {
            self.overlayView.alpha = self.overlayVisible ? 1.0 : 0.0
        }

        if overlayVisible && configuration.autoHideOverlay {
            startOverlayAutoHideTimer()
        }
    }

    private func startOverlayAutoHideTimer() {
        overlayTimer?.invalidate()
        overlayTimer = Timer.scheduledTimer(withTimeInterval: configuration.autoHideInterval, repeats: false) { [weak self] _ in
            self?.overlayVisible = false
            UIView.animate(withDuration: 0.25) {
                self?.overlayView.alpha = 0
            }
        }
    }

    // MARK: - Track Panel

    private func showTrackPanel() {
        trackPanelVisible = true
        let audios = engine.audioTracks()
        let subs = engine.subtitleTracks()
        trackPanel.configure(audio: audios, subtitles: subs)
        trackPanel.show()
    }

    private func hideTrackPanel() {
        trackPanelVisible = false
        trackPanel.hide()
    }

    // MARK: - Track Selection Delegate

    public func didSelectAudioTrack(index: Int) {
        engine.selectAudioTrack(index: index)
        delegate?.lcplayerDidChangeAudioTrack(index: index)
        updateTrackInfo()
    }

    public func didSelectSubtitleTrack(index: Int?) {
        engine.selectSubtitleTrack(index: index)
        delegate?.lcplayerDidChangeSubtitleTrack(index: index)
        updateTrackInfo()
    }

    // MARK: - Time & Buffer Observation

    private func startTimeObservation() {
        engine.addPeriodicTimeObserver { [weak self] time in
            guard let self,
                  let player = self.engine.player,
                  let item = player.currentItem else { return }

            let currentSeconds = CMTimeGetSeconds(time)
            let durationSeconds = CMTimeGetSeconds(item.duration)

            if currentSeconds.isFinite && currentSeconds >= 0 {
                let seconds = Int(currentSeconds)
                let m = seconds / 60
                let s = seconds % 60
                let text = String(format: "%02d:%02d", m, s)
                self.overlayView.setTimeText(text)
            }

            if durationSeconds.isFinite && durationSeconds > 0 && currentSeconds >= 0 {
                let progress = CGFloat(currentSeconds / durationSeconds)
                self.overlayView.setProgress(progress)
            } else {
                self.overlayView.setProgress(0)
            }

            if let buffered = self.engine.bufferedProgress() {
                self.overlayView.setBufferedProgress(CGFloat(buffered))
            } else {
                self.overlayView.setBufferedProgress(0)
            }
        }
    }

    // MARK: - Track Info

    private func updateTrackInfo() {
        let audios = engine.audioTracks()
        let subs = engine.subtitleTracks()

        let audioText = audios.first?.languageCode ?? audios.first?.name ?? "-"
        let subText = subs.first?.languageCode ?? subs.first?.name ?? "-"

        overlayView.setTrackInfo("\(audioText) | \(subText)")
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
}
