//
//  SummaryView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/21.
//

import SwiftUI
import HealthKit
import WatchKit

struct SummaryView: View {
    @EnvironmentObject var workoutmanager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        if workoutmanager.workout == nil{
            ProgressView("Saving workout")
                .toolbar(.hidden)
        } else {
            ScrollView{
                LazyVStack(alignment: .leading){
                    SummaryMetricView(title: "Total Time", value: durationFormatter.string(from: workoutmanager.workout?.duration ?? 0.0) ?? "")
                    if workoutmanager.session?.workoutConfiguration.locationType == .outdoor{
                        SummaryMetricView(title: "Total Distance", value: Measurement(value: workoutmanager.workout?.totalDistance?.doubleValue(for: .meter()) ?? 0, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(2)))))
                            .foregroundStyle(.green)
                    }
                    SummaryMetricView(title: "Total Energy", value: Measurement(value: workoutmanager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0, unit: UnitEnergy.kilocalories).formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                        .foregroundStyle(.pink)
                    SummaryMetricView(title: "Avg. Heart Rate", value: workoutmanager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + "bpm")
                        .foregroundStyle(.red)
                    Button("Done"){
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SummaryMetricView:View {
    var title: String
    var value: String
    
    var body: some View {
        Text(title)
            .foregroundStyle(.foreground)
        Text(value)
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
        Divider()
    }
}

