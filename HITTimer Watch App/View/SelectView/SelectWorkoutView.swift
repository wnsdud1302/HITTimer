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

extension HKWorkoutActivityType: Identifiable{
    public var id : UInt {
        rawValue
    }
    
    var name: String{
        switch self {
        case .running:
            return " 달리기"
        case .walking:
            return "걷기"
        case .highIntensityIntervalTraining:
            return "인터벌트레이닝"
        case .traditionalStrengthTraining:
            return "근력운동"
        default:
            return ""
        }
    }
    
    var image: Image{
        switch self{
        case .running:
            return Image(systemName: "figure.run")
        case .walking:
            return Image(systemName: "figure.walk")
        case .highIntensityIntervalTraining:
            return Image(systemName: "figure.highintensity.intervaltraining")
        case .traditionalStrengthTraining:
            return Image(systemName: "figure.strengthtraining.traditional")
        default:
            return Image(systemName: "figure.run")
        }
    }
}


