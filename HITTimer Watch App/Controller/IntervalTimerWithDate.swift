//
//  IntervalTimerWithDate.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/26.
//

import Foundation


class IntervalTimerWithDate: ObservableObject{
    
    var startSets: Int?
    
    var remainSets: Int?
    
    var timerStartDate: Date?
    
    var startDate: Date?
    
    var timeRemain: TimeInterval?
    
    var timers: [TimeInterval] = []
    
    
    @Published var endtimer: Bool = false {
        didSet{
            print("endtimer \(endtimer)")
            if endtimer == false {
                resetTimer()
            }
        }
    }
    
    func addTimers(_ wo: Int, _ rst: Int,_ sets: Int){
        startSets = sets
        remainSets = sets - 1
        for _ in 0..<sets {
            timers.append(TimeInterval(wo))
            timers.append(TimeInterval(rst))
        }
        timers.removeLast()
        print(timers)
        print("timers added")
    }
    
    func startTimer(){
        print("start timer")
        startDate = Date()
        timeRemain = timers.first
        timerStartDate = Date(timeIntervalSinceNow: timers.first!)
    }
    
    func endTimer(){
        self.endtimer = true
    }
    
    func getTimer(from fromDate: Date) -> TimeInterval{
        guard timeRemain != nil else {
            endTimer()
            timeRemain = 0
            timers.append(0)
            print("timeRemain is nil")
            return 0
        }
        let timeRemain = fromDate.distance(to: timerStartDate ?? Date())
        
        if timeRemain <= 0 {
            timers.removeFirst()
            self.timeRemain = timers.first
            timerStartDate = Date(timeIntervalSinceNow: self.timeRemain ?? 0)
            remainSets = timers.count / 2
            HapticFeedback.shared.sendFeedBack(.success)
            
        }
        print("timeRemain = \(timeRemain)")
        return timeRemain
    }
    
    func resetTimer(){
        timerStartDate = nil
        startDate = nil
        startSets = nil
        remainSets = nil
        timers.removeAll()
    }
    
    func checkType() -> String {
        if timeRemain == nil {
            return "끝"
        }
        if timers.count % 2 == 0 {
            return "휴식"
        }
        return "운동"
    }
    
    func checkRound() -> String {
        let numerator = (startSets ?? 1) - (remainSets ?? 1)
        let denumerator = startSets ?? 1
        
        return String("\(numerator) / \(denumerator)")
    }
}
