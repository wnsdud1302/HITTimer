//
//  StartView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/20.
//

import SwiftUI
import HealthKit

struct StartView: View {
    
    var workoutTypes: [HKWorkoutActivityType] = [.running, .walking, .traditionalStrengthTraining, .highIntensityIntervalTraining]
    
    var body: some View {
        TabView{
            Text("first page")
            List(workoutTypes){ type in
                Text(type.name)
            }
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
            return "TraditionalStrengthTraining"
        default:
            return ""
        }
    }
}

#Preview {
    StartView()
}
