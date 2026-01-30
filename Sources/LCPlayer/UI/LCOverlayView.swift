import UIKit

public final class LCOverlayView: UIView {

    private let topBar = UIView()
    private let bottomBar = UIView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let progressBackgroundView = UIView()
    private let bufferedView = UIView()
    private let progressFillView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTopBar()
        setupBottomBar()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
    }

    private func setupTopBar() {
        topBar.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        addSubview(topBar)

        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        titleLabel.text = "LCPlayer"
        topBar.addSubview(titleLabel)

        timeLabel.textColor = .white.withAlphaComponent(0.8)
        timeLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        timeLabel.text = ""
        topBar.addSubview(timeLabel)
    }

    private func setupBottomBar() {
        bottomBar.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        addSubview(bottomBar)

        progressBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        progressBackgroundView.layer.cornerRadius = 3
        progressBackgroundView.clipsToBounds = true
        bottomBar.addSubview(progressBackgroundView)

        bufferedView.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        bufferedView.layer.cornerRadius = 3
        bufferedView.clipsToBounds = true
        progressBackgroundView.addSubview(bufferedView)

        progressFillView.backgroundColor = UIColor.white
        progressFillView.layer.cornerRadius = 3
        progressFillView.clipsToBounds = true
        progressBackgroundView.addSubview(progressFillView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let safe = bounds.insetBy(dx: 40, dy: 40)

        let topHeight: CGFloat = 80
        topBar.frame = CGRect(x: safe.minX,
                              y: safe.minY,
                              width: safe.width,
                              height: topHeight)

        let bottomHeight: CGFloat = 80
        bottomBar.frame = CGRect(x: safe.minX,
                                 y: safe.maxY - bottomHeight,
                                 width: safe.width,
                                 height: bottomHeight)

        titleLabel.frame = CGRect(x: 24,
                                  y: 0,
                                  width: topBar.bounds.width - 48,
                                  height: topBar.bounds.height)

        timeLabel.frame = CGRect(x: topBar.bounds.width - 200 - 24,
                                 y: 0,
                                 width: 200,
                                 height: topBar.bounds.height)

        let progressWidth = bottomBar.bounds.width - 48
        let progressHeight: CGFloat = 6
        let progressX: CGFloat = 24
        let progressY = (bottomBar.bounds.height - progressHeight) / 2

        progressBackgroundView.frame = CGRect(x: progressX,
                                              y: progressY,
                                              width: progressWidth,
                                              height: progressHeight)

        // Mevcut genişlikleri koruyarak yükseklik/konum sabitleniyor
        let bufferedWidth = bufferedView.frame.width
        bufferedView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: bufferedWidth,
                                    height: progressBackgroundView.bounds.height)

        let currentFillWidth = progressFillView.frame.width
        progressFillView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: currentFillWidth,
                                        height: progressBackgroundView.bounds.height)
    }

    // MARK: - Public API

    public func setTitle(_ text: String) {
        titleLabel.text = text
    }

    public func setTimeText(_ text: String) {
        timeLabel.text = text
    }

    /// 0.0 - 1.0 arası oynatma progress
    public func setProgress(_ value: CGFloat) {
        let clamped = max(0, min(1, value))
        let totalWidth = progressBackgroundView.bounds.width
        let newWidth = totalWidth * clamped

        progressFillView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: newWidth,
                                        height: progressBackgroundView.bounds.height)
    }

    /// 0.0 - 1.0 arası buffer progress
    public func setBufferedProgress(_ value: CGFloat) {
        let clamped = max(0, min(1, value))
        let totalWidth = progressBackgroundView.bounds.width
        let newWidth = totalWidth * clamped

        bufferedView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: newWidth,
                                    height: progressBackgroundView.bounds.height)
    }
}
