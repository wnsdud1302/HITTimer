//
//  StartView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/20.
//

import SwiftUI
import HealthKit

struct SelectWorkoutView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var intervalTimer: IntervalTimer
    @EnvironmentObject var intervalTimerWithDate: IntervalTimerWithDate
    @Binding var activityType: HKWorkoutActivityType
    @Binding var showView: Bool
    
    var workoutTypes: [HKWorkoutActivityType] = [.running, .walking, .traditionalStrengthTraining, .highIntensityIntervalTraining]
    
    var body: some View {
        List{
            ForEach(workoutTypes){ type in
                Button(action:{
                    activityType = type
                    showView = false
                }){
                    StartViewCell(type: type)
                }
            }
        }
    }
}

struct StartViewCell: View {
    @State var type: HKWorkoutActivityType
    var body: some View {
        HStack{
            type.image
            Text(type.name)

        }
    }
}




