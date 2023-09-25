//
//  StartView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/20.
//

import SwiftUI
import HealthKit

struct S: View {
    
    @Bindable var timerdata: TimerData
    
    var workoutTypes: [HKWorkoutActivityType] = [.running, .walking, .traditionalStrengthTraining, .highIntensityIntervalTraining]
    
    var body: some View {
        List{
            ForEach(workoutTypes){ type in
                
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
            return " Run"
        case .walking:
            return "walking"
        case .highIntensityIntervalTraining:
            return "HIITraining"
        case .traditionalStrengthTraining:
            return "StrengthTraining"
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

#Preview {
    StartView(timerdata: .init(totaltime: 0, wotime: 0, rstime: 0, sets: 0))
}
