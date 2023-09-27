//
//  TimerListView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/21.
//

import SwiftUI
import SwiftData
import HealthKit

struct TimerListView: View {
    @EnvironmentObject var datamanager: DataManager
    @EnvironmentObject var intervaltimer: IntervalTimer
    @EnvironmentObject var intervalTimerWithDate: IntervalTimerWithDate
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State var activityType: HKWorkoutActivityType = .running
    @State var showSelect: Bool = false
    @State var showSession: Bool = false
    
    @Query() private var timerdatas: [TimerData]
    
    
    var body: some View {
        List{
            ForEach(timerdatas){ td in
                Button(action:{
                    showSession = true
                    intervalTimerWithDate.addTimers(td.wotime, td.rstime, td.sets)
                }){
                    TimerListCell(activityType: $activityType, timerdata: td)
                }
            }
            .onDelete(perform: removeRow)
            .navigationDestination(isPresented: $showSession){
                SessionPagingView(activityType: $activityType, showView: $showSession)
            }
        }
        .listStyle(.carousel)
        .onChange(of: timerdatas){
            print(timerdatas.count)
        }
        .onAppear{
            workoutManager.requestAuthorization()
        }
    }
}

extension TimerListView {
    func removeRow(at offset: IndexSet){
        for i in offset{
            datamanager.deleteData(which: timerdatas[i])
        }
    }
}

struct TimerListCell: View {
    @Binding var activityType: HKWorkoutActivityType
    @Bindable var timerdata: TimerData
    @State var showselect: Bool = false
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack{
                    Text("세트수: \(timerdata.sets)")
                        .foregroundStyle(.green)
                        .font(.system(size: 30))

                     Spacer()
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .onTapGesture {
                            showselect = true
                        }
                        .navigationDestination(isPresented: $showselect){
                            SelectWorkoutView(activityType: $activityType, showView: $showselect)
                        }
                }
                Text("운동시간: \(secondsToMS(timerdata.wotime))")
                    .foregroundStyle(.yellow)
                Text("휴식시간: \(secondsToMS(timerdata.rstime))")
                    .foregroundStyle(.yellow)
                Text("운동종류: \(activityType.name)")
            }
            .font(.system(.subheadline ,design: .rounded).monospacedDigit().lowercaseSmallCaps())
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

