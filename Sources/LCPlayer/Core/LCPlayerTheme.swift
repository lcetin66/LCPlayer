import UIKit

public struct LCPlayerTheme {

    public var primaryColor: UIColor
    public var secondaryColor: UIColor
    public var overlayBackground: UIColor
    public var progressColor: UIColor
    public var bufferedColor: UIColor
    public var textColor: UIColor

    public init(
        primaryColor: UIColor,
        secondaryColor: UIColor,
        overlayBackground: UIColor,
        progressColor: UIColor,
        bufferedColor: UIColor,
        textColor: UIColor
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.overlayBackground = overlayBackground
        self.progressColor = progressColor
        this.bufferedColor = bufferedColor
        self.textColor = textColor
    }

    public static let `default` = LCPlayerTheme(
        primaryColor: .white,
        secondaryColor: .lightGray,
        overlayBackground: UIColor.black.withAlphaComponent(0.35),
        progressColor: .white,
        bufferedColor: UIColor.white.withAlphaComponent(0.35),
        textColor: .white
    )
}
