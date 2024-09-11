import AVFoundation

class AudioPlayerHandler {
    
    private var audioPlayer: AVAudioPlayer?
    
    // Singleton pattern for global access (optional)
    static let shared = AudioPlayerHandler()

    private init() {
        // Prevent external initialization
    }

    func loadAudioFile(named fileName: String, fileExtension: String) -> Bool {
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Audio file not found")
            return false
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            return true
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
            return false
        }
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func stop() {
        audioPlayer?.stop()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func setVolume(_ volume: Float) {
        audioPlayer?.volume = volume
    }
    
    func setNumberOfLoops(_ loops: Int) {
        audioPlayer?.numberOfLoops = loops
    }
}
