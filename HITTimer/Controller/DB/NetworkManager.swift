//
//  Network.swift
//  HITTimer
//
//  Created by 박준영 on 10/13/23.
//

import Foundation
import HealthKit

class NetworkManager{
    
    var session = URLSession.shared
    
    func encode(from data: HKWorkout) -> Data?{
        let encoder = JSONEncoder()
        let name = data.workoutActivityType.name
        let heartRate = data.statistics(for: HKQuantityType(.heartRate))?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0
        let activeEnergyBurned = data.statistics(for: HKQuantityType(.heartRate))?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0
        let distance = data.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
        let data = HealthData(name: name, heartRate: heartRate, activeEnergyBurned: activeEnergyBurned, distanceWalkingRunning: distance)
        let json = try? encoder.encode(data)
        return json
    }
    
    func upload(from data: HKWorkout, to url: String) {
        guard let json = encode(from: data) else {
            return
        }
        let url = URL(string: url)
        var request = URLRequest(url: url!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.uploadTask(with: request, from: json){ data, response, error in
            
            if let error = error {
                    print ("error: \(error)")
                    return
                }
            
            guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
                }
            
            if let mimeType = response.mimeType,
                    mimeType == "application/json",
                    let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print ("got data: \(dataString)")
                }
        }
        task.resume()
    }
}
