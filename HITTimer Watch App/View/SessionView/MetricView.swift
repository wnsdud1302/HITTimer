//
//  MetricView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/21.
//

import SwiftUI
import HealthKit

struct MetricView: View {
    @EnvironmentObject var workoutmanager: WorkoutManager
    var body: some View {
        TimelineView(MetricTimeLineSchedule(from: workoutmanager.builder?.startDate ?? Date(), isPaused: workoutmanager.session?.state == .paused)){ context in
            VStack(alignment: .leading){
                IntervalTimerView()
                    .foregroundStyle(.yellow)
                Text(Measurement(value: workoutmanager.activeEnergy, unit: UnitEnergy.kilocalories)
                    .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0))))
                )
                Text(workoutmanager.heartRate.formatted(.number.precision(.fractionLength(0))) + "bpm")
                if workoutmanager.session?.workoutConfiguration.locationType == .outdoor{
                    Text(Measurement(value: workoutmanager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
                }
            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }
}

struct IntervalTimerView: View {
    @EnvironmentObject var intervaltimer: IntervalTimer
    @State var time = 0
    
    var body: some View {
        Text(secondsToMS(time))
            .fontWeight(.semibold)
            .onReceive(intervaltimer.$timeRemain, perform: {
                time = $0
            })
    }
    func secondsToMS(_ seconds: Int)->String{
        let min = String(format: "%02d", seconds % 3600 / 60)
        let sec = String(format: "%02d", seconds % 3600 % 60)
        return "\(min):\(sec)"
    }
}


private struct MetricTimeLineSchedule: TimelineSchedule{
    var startDate: Date
    var isPaused: Bool
    
    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
    
}

#Preview {
    MetricView()
}
