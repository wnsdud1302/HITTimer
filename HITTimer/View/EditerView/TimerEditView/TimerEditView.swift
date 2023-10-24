//
//  TimerEditView.swift
//  simpleHITClock
//
//  Created by 박준영 on 2023/08/08.
//

import SwiftUI
import UIKit


let timeArray = Array(1...60)
let setArray = Array(1...40)

struct TimerEditView: View {
    
    var timeArray = Array(0...59)

    @Binding var minute: Int
    @Binding var second: Int
    
    var body: some View {
        VStack{
            Text("시간설정")
                .font(.system(size: 70))
                .fontWeight(.bold)
                .padding(.bottom,100)
            HStack{
                Text("\(minute) 분 \(second) 초")
                    .font(.system(size: 30))
                    .fontWeight(.light)
            }
            TimePickerView(array: timeArray, minSelected: $minute, secSelected: $second)
                .frame(height: 100)
                .compositingGroup()
                .clipped()
        }
    }
    
    func secondsToHMS(_ seconds: Int) -> String{
        return "\(seconds / 3600) : \((seconds % 3600) / 60) : \((seconds % 3600) % 60)"
    }
    func minuteToSec(_ min: Int) -> Int{
        return min * 60
    }
    func hourToSec(_ hour: Int) -> Int {
        return hour * 3600
    }
}
