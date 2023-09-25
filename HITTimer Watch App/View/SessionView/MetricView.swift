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
    @EnvironmentObject var intervalTimer: IntervalTimer
    
    @State var showSubseconds = false
    var body: some View {
        TimelineView(MetricTimeLineSchedule(from: workoutmanager.builder?.startDate ?? Date(), isPaused: workoutmanager.session?.state == .paused)){ context in
            VStack(alignment: .leading){
                Text(intervalTimer.checkType())
                Text(intervalTimer.checkRound())
                TimeView(showSubseconds: $showSubseconds)
                    .foregroundStyle(.yellow)
                Text(Measurement(value: workoutmanager.activeEnergy, unit: UnitEnergy.kilocalories)
                    .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0))))
                )
                Text(workoutmanager.heartRate.formatted(.number.precision(.fractionLength(0))) + "bpm")
                if workoutmanager.session?.workoutConfiguration.locationType == .outdoor{
                    Text(Measurement(value: workoutmanager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
                }
            }
            .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
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
        var baseSchedule = PeriodicTimelineSchedule(from: startDate, by: (mode == .lowFrequency ? 1 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
    
}

