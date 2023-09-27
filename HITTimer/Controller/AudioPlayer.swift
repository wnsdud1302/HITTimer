//
//  AudioPlayer.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/23.
//

import Foundation
import AVFoundation
import AVKit


class AudioPlayer: ObservableObject{
    
    static let shared = AudioPlayer()
    
    private var session: AVAudioSession?
    private var player: AVPlayer?
    
    
    @Published var time = 0.0
    
    var active: Bool = false {
        didSet{
            setSession()
        }
    }
    
    func makeSession(){
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(.playback, mode: .default, policy: .default, options: .duckOthers)
        } catch {
            print(error)
        }
        print("avaudio session start")
        self.session = session
    }
//    func makeCountDown(_ count: String){
//        let utterance = AVSpeechUtterance(string: count)
//        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
//        tts?.speak(utterance)
//        tts?.usesApplicationAudioSession = true
//    }
    
    func setSession(){
        do{
            try self.session?.setActive(active)
            print(active ? "session active" : "session deactive")
        } catch {
            print(error)
        }
    }
    
    func activeToggle(){
        if active == false{
            active = true
        } else {
            active = false
        }
    }
    
    func makePlayer(){
        self.player = AVPlayer(url: URL(filePath:Bundle.main.path(forResource: "sample", ofType: "mp3")!))
        player?.volume = 0.2
        player?.playImmediately(atRate: 0)
        player?.play()
    }
    
    func makePlayer(file : AVPlayerItem?){
        makeSession()
        guard file != nil else {
            print("file is nil")
            return
        }
        player = AVPlayer(playerItem: file)
    }
    
    func getPlayer() -> AVPlayer?{
        return self.player
    }
    
    func pause(){
        player?.pause()
    }
    
    func resume(){
        player?.play()
    }
    
    func end(){
        player = nil
        session = nil
    }
    
    
    func mergeAudioFiles(totalTime: Int) async -> AVPlayerItem?{
        
        guard let path = Bundle.main.path(forResource: "1hour", ofType: "mp3") else {
            print("file doesn't exist")
            return nil
        }
        let composition = AVMutableComposition()
        let repeatfile = Int(ceil(Double(totalTime) / Double(3600)))
        for _ in 0..<repeatfile {
            let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            
            let asset = AVURLAsset(url: URL(filePath: path))
            
            let tracks = try! await asset.load(.tracks)
            
            guard tracks.count > 0  else { return nil }
            
            let audioTrack = tracks[0]
            
            let duration = try! await audioTrack.load(.timeRange)
            
            let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 600), duration: duration.duration)
            try! compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: composition.duration)
            print("file add")
        }
        
        let newasset = AVPlayerItem(asset: composition)        
        return newasset
    }
}
