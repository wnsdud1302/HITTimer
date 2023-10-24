//
//  HealthData.swift
//  HITTimer
//
//  Created by 박준영 on 10/16/23.
//

import Foundation


struct HealthData: Codable{
    let name: String
    let heartRate: Double
    let activeEnergyBurned: Double
    let distanceWalkingRunning: Double
}
