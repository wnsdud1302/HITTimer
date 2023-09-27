//
//  WorkoutManager.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/19.
//

import Foundation
import CoreLocation
import MapKit
import HealthKit


class WorkoutManager:NSObject, ObservableObject{
    
    @Published var running = false
    
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    let healthStore = HKHealthStore()
    
    func requestAuthorization(){
        let typesToshare: Set = [
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToshare, read: typesToRead) { success, error in
        }
    }
    
#if os(iOS)
    
//    func requestAuthorization(){
//        let typesToshare: Set<HKSampleType> = [
//            .workoutType(),
//            HKSeriesType.workoutRoute()
//        ]
//        
//        let typesToRead: Set<HKSampleType> = [
//                            .workoutType(),
//                             HKSeriesType.workoutType(),
//                             HKSeriesType.workoutRoute(),
//                             HKObjectType.quantityType(forIdentifier: .heartRate)!,
//                             HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
//        ]
//        
//        healthStore.requestAuthorization(toShare: typesToshare, read: typesToRead) { success, error in
//        }
//    }
    
    func getWorkouts(completion: @escaping ([HKWorkout]?, Error?) -> Void) async {
        let source = HKQuery.predicateForObjects(from: .default())
        
        let sorDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: source, limit: HKObjectQueryNoLimit, sortDescriptors: [sorDescriptor]){ (query, samples, error) in
            guard let samples = samples as? [HKWorkout], error == nil else {
                completion(nil, error)
                return
            }
            completion(samples, nil)
        }
        healthStore.execute(query)
    }
#endif
    
    
#if os(watchOS)
    var builder: HKLiveWorkoutBuilder?
    
    var session: HKWorkoutSession?
    
    @Published var showingSummaryView: Bool = false {
        didSet{
            if showingSummaryView == false {
                resetWorktout()
            }
        }
    }
    
   
    
    func startWorkout(workoutType: HKWorkoutActivityType, locationType: HKWorkoutSessionLocationType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = locationType
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }
        
        session?.delegate = self
        builder?.delegate = self
        
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate){ success, error in
        }
        print("startWorkout")
    }
    
    
    func togglePause(){
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    func pause(){
        session?.pause()
    }
    
    func resume(){
        session?.resume()
    }
    
    func endWorkout(){
        session?.end()
        showingSummaryView = true
        print("endWorkout")
    }
    
    func updateForStatistics(_ statistics: HKStatistics?){
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    func resetWorktout() {
        builder = nil
        workout = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
#endif
}


#if os(watchOS)
extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
    
    
}

#endif


extension HKWorkout: Identifiable{
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
