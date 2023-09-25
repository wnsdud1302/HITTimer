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
    
    @Published var running = false
    
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
        if self.running == true {
            stopTimers()
        } else {
            startTimers()
        }
    }
    
    func stopTimers(){
        self.running = false
    }
    
    func startTimers(){
        self.running = true
        
        AudioPlayer.shared.getPlayer()?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: .main){ [self] in
            if $0.seconds == .zero {
                return
            }
            print("intervaltimer: \($0.seconds)")
            guard timers.first != nil else {
                endTimer()
                return
            }
            if timeRemain > -1{
                timeRemain -= 1
            }
            if timeRemain == -1 {
                timers.removeFirst()
                timeRemain = (timers.first ?? 1)  - 1
                
            }
        }
//        AudioPlayer.shared.$time.sink{ [self] _ in
//            guard timers.first != nil else {
//                endTimer()
//                return
//            }
//            if timeRemain > -1{
//                timeRemain -= 1
//            }
//            if timeRemain == -1 {
//                timers.removeFirst()
//                timeRemain = (timers.first ?? 1)  - 1
//                
//            }
//
//        }
//        .store(in: &cancellable)
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
