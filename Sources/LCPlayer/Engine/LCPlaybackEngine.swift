import AVFoundation

public enum LCPlaybackState {
    case idle
    case loading
    case playing
    case paused
    case failed(Error)
}

public final class LCPlaybackEngine: NSObject {

    public private(set) var player: AVPlayer?
    public private(set) var state: LCPlaybackState = .idle

    private var timeObserver: Any?

    public override init() {
        super.init()
    }

    public func load(url: URL) {
        state = .loading
        let item = AVPlayerItem(url: url)

        player = AVPlayer(playerItem: item)

        observeStatus(item: item)
    }

    public func play() {
        player?.play()
        state = .playing
    }

    public func pause() {
        player?.pause()
        state = .paused
    }

    public func replace(url: URL) {
        let item = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: item)
        observeStatus(item: item)
    }

    private func observeStatus(item: AVPlayerItem) {
        item.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
    }

    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == "status",
              let item = object as? AVPlayerItem else { return }

        switch item.status {
        case .readyToPlay:
            state = .playing
            player?.play()

        case .failed:
            state = .failed(item.error ?? NSError(domain: "LCPlayer", code: -1))

        default:
            break
        }
    }

    // MARK: - Time Observer

    public func addPeriodicTimeObserver(
        interval: CMTime = CMTime(seconds: 1, preferredTimescale: 1),
        handler: @escaping (CMTime) -> Void
    ) {
        guard let player = player else { return }

        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            handler(time)
        }
    }

    public func removeTimeObserver() {
        if let observer = timeObserver, let player = player {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    deinit {
        removeTimeObserver()
    }

    // MARK: - Buffered Range

    public func bufferedProgress() -> Double? {
        guard
            let item = player?.currentItem,
            item.duration.isNumeric,
            item.duration.seconds > 0,
            let range = item.loadedTimeRanges.first?.timeRangeValue
        else {
            return nil
        }

        let bufferedTime = range.start.seconds + range.duration.seconds
        let total = item.duration.seconds
        guard bufferedTime >= 0, total > 0 else { return nil }

        return min(bufferedTime / total, 1.0)
    }
}
