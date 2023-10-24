//
//  SummaryView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/24.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @ObservedObject var workoutmanager = WorkoutManager()
    
    @State var workList: [HKWorkout] = []
    
    var body: some View {
        VStack{
            List{
                ForEach(workList){ workout in
                    Button("show statics"){
                        print(HKWorkoutActivityType.walking.rawValue)
                        print(HKWorkoutActivityType.traditionalStrengthTraining.rawValue)
                        print(HKWorkoutActivityType.running.rawValue)
                        print(HKWorkoutActivityType.highIntensityIntervalTraining.rawValue)
                        print(workout.workoutActivityType.rawValue)
                        print(workout.duration)
                        print(workout.statistics(for: HKQuantityType(.heartRate))?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) as Any)
                        print(workout.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) as Any)
                        print(workout.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: HKUnit.meter()) as Any)
                    }
                }
            }
            Text("read to read workout")
            Button("show"){
                print(workList.count)
            }
        }
        .onAppear{
            Task{
                await workoutmanager.getWorkouts{ workouts, error in
                    guard workouts != nil else {
                        print(error!)
                        return
                    }
                    self.workList = workouts!
                }
            }
            workoutmanager.requestAuthorization()
            
        }
    }
}


