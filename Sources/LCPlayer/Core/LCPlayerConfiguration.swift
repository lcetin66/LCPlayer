import UIKit

public struct LCPlayerConfiguration {

    public var showsTopBar: Bool
    public var showsBottomBar: Bool
    public var autoHideOverlay: Bool
    public var autoHideInterval: TimeInterval
    public var theme: LCPlayerTheme

    public init(
        showsTopBar: Bool = true,
        showsBottomBar: Bool = true,
        autoHideOverlay: Bool = true,
        autoHideInterval: TimeInterval = 4.0,
        theme: LCPlayerTheme = .default
    ) {
        self.showsTopBar = showsTopBar
        self.showsBottomBar = showsBottomBar
        self.autoHideOverlay = autoHideOverlay
        self.autoHideInterval = autoHideInterval
        self.theme = theme
    }
}
