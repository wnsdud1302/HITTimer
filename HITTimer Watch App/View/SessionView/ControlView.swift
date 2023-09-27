//
//  ControlView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/21.
//

import SwiftUI

struct ControlView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var intervalTimer: IntervalTimer
    @EnvironmentObject var intervalTimerWithDate: IntervalTimerWithDate

    var body: some View {
        HStack {
            VStack {
                Button {
                    workoutManager.endWorkout()
                    intervalTimerWithDate.endTimer()
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                }
                .tint(.yellow)
                .font(.title2)
                Text(workoutManager.running ? "Pause" : "Resume")
            }
        }
    }
}

