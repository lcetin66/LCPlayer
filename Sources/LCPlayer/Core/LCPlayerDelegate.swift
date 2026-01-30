import Foundation

public protocol LCPlayerDelegate: AnyObject {
    func lcplayerDidStartPlaying()
    func lcplayerDidPause()
    func lcplayerDidFail(error: Error)
    func lcplayerDidChangeAudioTrack(index: Int)
    func lcplayerDidChangeSubtitleTrack(index: Int?)
}
