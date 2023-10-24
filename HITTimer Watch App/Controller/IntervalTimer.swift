//
//  IntervalTimer.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/23.
//

import Foundation
import SwiftUI
import Combine


class IntervalTimer: ObservableObject{
    
    let time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var timers: [Double] = []
    
    @Published var sets = 1
    
    private var cancellable: Set<AnyCancellable> = Set()
    
    @Published var running = false
    
    @Published var endtimer: Bool = false {
        didSet{
            if endtimer == false{
                resetTimer()
            }
        }
    }
    
    @Published var timeRemain: TimeInterval = 0.0
    
    
    
    func addTimers(_ wo: Int, _ rst: Int,_ sets: Int){
        
        for _ in 0..<sets {
            timers.append(Double(wo))
            timers.append(Double(rst))
        }
        self.sets = sets
        timers.removeLast()
    }
    
    func toggleTimer(){
        if self.running == true {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    
    func startTimer() {
        self.running = true
        print(timers.count)
        time.sink{ [self]_ in
            guard timers.first != nil else {
                endTimer()
                return
            }
                
            if timeRemain <= 0 {
                print("reomve from timers")
                HapticFeedback.shared.sendFeedBack(.success)
                timers.removeFirst()
                timeRemain = (timers.first ?? 1) - 1
                return
            }
            
            if timeRemain >= 3.00 && timeRemain < 3.01 {
                HapticFeedback.shared.sendFeedBack(.start)
            }
            if timeRemain >= 2.00 && timeRemain < 2.01 {
                HapticFeedback.shared.sendFeedBack(.start)
            }
            if timeRemain >= 1.00 && timeRemain < 1.01 {
                HapticFeedback.shared.sendFeedBack(.start)
            }

            print(timeRemain)
            timeRemain -= 1
        }
        .store(in: &cancellable)
    }
    
    func stopTimer(){
        self.running = false
        timers.removeAll()
        time.upstream.connect().cancel()
    }
    
    func endTimer(){
        self.endtimer = true
        stopTimer()
    }
    
    func resetTimer(){
        print("resettimer")
        stopTimer()
        timers.removeAll()
    }
    
    func checkType() -> String{
        if timers.first == nil{
            return "끝"
        }
        if timers.count % 2 == 0 {
            return "휴식"
        }
        return "운동"
    }
    
    func checkRound() -> String{
        
        let numerator = sets - timers.count / 2
        let denumerator = sets
        
        return String(format: "\(numerator) / \(denumerator)", numerator, denumerator)
    }
}
