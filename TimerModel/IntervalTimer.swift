//
//  Timer.swift
//  simpleHITClock
//
//  Created by 박준영 on 2023/07/05.
//

import Foundation
import Combine



class IntervalTimer: ObservableObject{
    
    static let shared = IntervalTimer()
    
    var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var timers: [Int] = []
    
    @Published var timeRemain = 0
    
    private var cancellable: Set<AnyCancellable> = Set()

    func addTimers(_ wo: Int,_ rst: Int, _ sets: Int){
        
        for _ in 0..<sets{
            timers.append(wo)
            timers.append(rst)
        }
    }
    
    func stopTimers(){
        time.upstream.connect().cancel()
    }
    
    
    func startTimers(){
        time.sink{ [self] _ in
            guard timers.first != nil else {
                return
            }
            if timeRemain > -1{
                timeRemain -= 1
            }
            if timeRemain == -1 {
                timers.removeFirst()
                timeRemain = (timers.first ?? 0)  - 1
                
            }

        }
        .store(in: &cancellable)
    }
    
    func skipTimer(){
        timers.removeFirst()
        guard timers.first != nil else {
            timeRemain = 0
            return
        }
        timeRemain = timers.first!
    }
}

extension IntervalTimer{
    
    func secondsToHMS(_ seconds: Int) -> String{
        return "\((seconds % 3600) / 60)분 \((seconds % 3600) % 60)초"
    }
}
