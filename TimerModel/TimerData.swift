//
//  Timer.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/21.
//

import Foundation
import SwiftData

@Model
final class TimerData{
    var totaltime: Int
    var wotime: Int
    var rstime: Int
    var sets: Int
    
    init(totaltime: Int, wotime: Int, rstime: Int, sets: Int) {
        self.totaltime = totaltime
        self.wotime = wotime
        self.rstime = rstime
        self.sets = sets
    }
    
}
