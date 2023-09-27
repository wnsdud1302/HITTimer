//
//  TimerSavedView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/21.
//

import SwiftUI
import SwiftData
import SwipeActions

struct TimerSavedView: View {
    
    @EnvironmentObject var datamanager: DataManager
    @EnvironmentObject var intervaltimer: IntervalTimer
    
    @Environment(\.modelContext) private var context
    @Query() private var timerdatas:[TimerData]
    
    @Binding var start: Bool
    
    @Binding var totalTime: Int
    
    @State var tapCell = false
    
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(timerdatas){ td in
                    
                    TimerCell(timerdata: td)
                        .addFullSwipeAction(swipeColor: .clear, swipeRole: .destructive) {
                            Leading{
                                Text("new")
                            }
                            Trailing{
                                Button(action:{
                                    datamanager.context?.delete(td)
                                }){
                                    Image(systemName: "trash")
                                        .font(.system(size: 30))
                                        .foregroundStyle(Color.white)
                                        .frame(width: 80,height:120)
                                        .background(Color.red)
                                        .clipShape(.rect(cornerRadius:15))
                                        .padding(.trailing)
                                }
                            }
                        } action:{
                            datamanager.context?.delete(td)
                        }
                        .onTapGesture{
                            totalTime = td.totaltime
                        intervaltimer.addTimers(td.wotime, td.rstime, td.sets)
                        start = true
                    }
                }// foreach
            }
        }//List
    }// body
}

public extension Color {

    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}

struct TimerCell: View {
    @Bindable var timerdata: TimerData
    var body: some View {
        VStack{
            HStack{
                Text("총시간: "+secondsToHMS(timerdata.totaltime))
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .padding(.trailing)
                Text("세트수: "+String(timerdata.sets))
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            .padding(.bottom)
            HStack{
                Text("운동시간: "+secondsToMS(timerdata.wotime))
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .padding(.trailing)
                Text("휴식시간: "+secondsToMS(timerdata.rstime))
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            .ignoresSafeArea(edges: .all)
        }
        .frame(width: 350, height: 120)
        .background(Color.black.opacity(0.1))
        .background(Color.random())
        .clipShape(.rect(cornerRadius: 15))
    }
}

extension TimerCell{
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
