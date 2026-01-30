public protocol LCPlayable {
    var url: URL { get }
}

public struct LCStream: LCPlayable {
    public let url: URL
    public init(url: URL) {
        self.url = url
    }
}
