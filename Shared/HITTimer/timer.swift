//
//  timer.swift
//  simpleHITClock
//
//  Created by 박준영 on 2023/08/08.
//

import Foundation


class timer: ObservableObject{
    var timer: Timer?
    
    @Published var remain: Int = 0
    
    @Published var over = false
    
    init(_ remain: Int){
        self.remain = remain
    }
    
    func runCountDown(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ [self] in
            if remain == 0 {
                over = true
                $0.invalidate()
                return
            }
            remain -= 1
        }
    }
    
    func runStopWatch(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            self.remain += 1
        }
    }
    
    func stop(){
        guard timer != nil else {
            return 
        }
        timer!.invalidate()
        print(timer!.invalidate())
    }
}
