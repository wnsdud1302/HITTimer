//
//  TimerListView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/21.
//

import SwiftUI
import SwiftData

struct TimerListView: View {
    @EnvironmentObject var datamanager: DataManager
    @EnvironmentObject var intervaltimer: IntervalTimer
    
    @Query() private var timerdatas: [TimerData]
    
    var body: some View {
        List{
            ForEach(timerdatas){ td in
                NavigationLink(destination: StartView(timerdata: td)){
                    TimerListCell(timerdata: td)
                }
            }
        }
        .listStyle(.carousel)
        .onChange(of: timerdatas){
            print(timerdatas.count)
        }
    }
}

struct TimerListCell: View {
    @Bindable var timerdata: TimerData
    var body: some View {
        VStack(alignment: .leading){
            Text("세트수: \(timerdata.sets)")
                .font(.largeTitle)
            Text("운동시간: \(secondsToMS(timerdata.wotime))")
                .font(.subheadline)
            Text("휴식시간: \(secondsToMS(timerdata.rstime))")
                .font(.subheadline)
            
        }
    }
}

extension TimerListCell{
    func secondsToHMS(_ seconds: Int) -> String{
        return "\(seconds / 3600)시간 \((seconds % 3600) / 60)분 \((seconds % 3600) % 60)초"
    }
    func minuteToSec(_ min: Int) -> Int{
        return min * 60
    }
    func hourToSec(_ hour: Int) -> Int {
        return hour * 3600
    }
    
    func secondsToMS(_ seconds: Int)->String{
        let min = String(format: "%02d", seconds % 3600 / 60)
        let sec = String(format: "%02d", seconds % 3600 % 60)
        return "\(min):\(sec)"
    }
    
    func totalSec(_ hours: Int, _ minutes: Int, _ seconds: Int) -> Int{
        return hourToSec(hours) + minuteToSec(minutes) + seconds
    }
}

#Preview {
    TimerListView()
}
