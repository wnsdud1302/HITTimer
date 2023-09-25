//
//  Timer.swift
//  simpleHITClock
//
//  Created by 박준영 on 2023/07/05.
//

import Foundation
import Combine
import AVFoundation



class IntervalTimer: ObservableObject{
    
    static let shared = IntervalTimer()
    
    var timers: [Int] = []
    
    @Published var running = false {
        didSet{
            if running == true {
                resumeTimer()
            } else {
                stopTimers()
            }
        }
    }
    
    @Published var endtimer: Bool = false {
        didSet{
            if endtimer == false{
                resetTimer()
            } else {
                endtimer = false
            }
        }
    }
    
    @Published var timeRemain = 0
    
    private var cancellable: Set<AnyCancellable> = Set()

    func addTimers(_ wo: Int,_ rst: Int, _ sets: Int){
        
        for _ in 0..<sets{
            timers.append(wo)
            timers.append(rst)
        }
        timers.removeLast()
    }
    
    func toggleTimer(){
        running = !running
    }
    
    func stopTimers(){
        AudioPlayer.shared.pause()
    }
    
    func startTimers(){
        self.running = true
        print("start timer")
        AudioPlayer.shared.getPlayer()?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: .main){ [self] in
            if $0.seconds == .zero {
                return
            }
            print("intervaltimer: \($0.seconds)")
            guard timers.first != nil else {
                endTimer()
                return
            }
            if timeRemain <= 0{
                HapticFeedback.shared.notification(.success)
                timers.removeFirst()
                timeRemain = (timers.first ?? 1) - 1
                return
            }
            if timeRemain < 4 && timeRemain != 0{
                HapticFeedback.shared.play(.light)
            }
            timeRemain -= 1
        }

    }
    
    func resumeTimer(){
        AudioPlayer.shared.resume()
    }
    
    func endTimer(){
        self.endtimer = true
        stopTimers()
    }
    
    func resetTimer(){
        print("resettimer")
        stopTimers()
        timers.removeAll()
    }
    
    func skipTimer(){
        timers.removeFirst()
        guard timers.first != nil else {
            timeRemain = 0
            return
        }
        timeRemain = timers.first!
    }
    
    func checkType() -> String{
        if timers.count == 0{
            return "끝"
        }
        else if timers.count % 2 == 0 {
            return "휴식"
        }
        return "운동"
    }
}

extension IntervalTimer{
    
    func secondsToHMS(_ seconds: Int) -> String{
        return "\((seconds % 3600) / 60)분 \((seconds % 3600) % 60)초"
    }
}
