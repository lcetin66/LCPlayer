import UIKit

public protocol LCTrackSelectionViewDelegate: AnyObject {
    func didSelectAudioTrack(index: Int)
    func didSelectSubtitleTrack(index: Int?)
}

public final class LCTrackSelectionView: UIView {

    public weak var delegate: LCTrackSelectionViewDelegate?

    private let container = UIView()
    private let audioLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var audioButtons: [UIButton] = []
    private var subtitleButtons: [UIButton] = []
    private var noneSubtitleButton: UIButton?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupContainer()
        setupLabels()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        alpha = 0
    }

    private func setupContainer() {
        container.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        addSubview(container)
    }

    private func setupLabels() {
        audioLabel.text = "Audio Tracks"
        audioLabel.textColor = .white
        audioLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        container.addSubview(audioLabel)

        subtitleLabel.text = "Subtitle Tracks"
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        container.addSubview(subtitleLabel)
    }

    public func configure(audio: [LCAudioTrack], subtitles: [LCSubtitleTrack]) {
        audioButtons.forEach { $0.removeFromSuperview() }
        subtitleButtons.forEach { $0.removeFromSuperview() }
        noneSubtitleButton?.removeFromSuperview()

        audioButtons = audio.enumerated().map { index, track in
            let button = makeButton(title: track.name)
            button.tag = index
            button.addTarget(self, action: #selector(audioTapped(_:)), for: .primaryActionTriggered)
            container.addSubview(button)
            return button
        }

        noneSubtitleButton = makeButton(title: "None")
        noneSubtitleButton?.tag = -1
        noneSubtitleButton?.addTarget(self, action: #selector(subtitleTapped(_:)), for: .primaryActionTriggered)
        container.addSubview(noneSubtitleButton!)

        subtitleButtons = subtitles.enumerated().map { index, track in
            let button = makeButton(title: track.name)
            button.tag = index
            button.addTarget(self, action: #selector(subtitleTapped(_:)), for: .primaryActionTriggered)
            container.addSubview(button)
            return button
        }

        setNeedsLayout()
    }

    private func makeButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let width: CGFloat = bounds.width * 0.6
        let height: CGFloat = bounds.height * 0.7
        container.frame = CGRect(
            x: (bounds.width - width) / 2,
            y: (bounds.height - height) / 2,
            width: width,
            height: height
        )

        audioLabel.frame = CGRect(x: 40, y: 40, width: width - 80, height: 40)

        var y = audioLabel.frame.maxY + 20
        for button in audioButtons {
            button.frame = CGRect(x: 40, y: y, width: width - 80, height: 50)
            y += 60
        }

        subtitleLabel.frame = CGRect(x: 40, y: y + 20, width: width - 80, height: 40)
        y = subtitleLabel.frame.maxY + 20

        if let none = noneSubtitleButton {
            none.frame = CGRect(x: 40, y: y, width: width - 80, height: 50)
            y += 60
        }

        for button in subtitleButtons {
            button.frame = CGRect(x: 40, y: y, width: width - 80, height: 50)
            y += 60
        }
    }

    @objc private func audioTapped(_ sender: UIButton) {
        delegate?.didSelectAudioTrack(index: sender.tag)
    }

    @objc private func subtitleTapped(_ sender: UIButton) {
        if sender.tag == -1 {
            delegate?.didSelectSubtitleTrack(index: nil)
        } else {
            delegate?.didSelectSubtitleTrack(index: sender.tag)
        }
    }

    public func show() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    public func hide() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        }
    }
}
