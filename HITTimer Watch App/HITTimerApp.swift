//
//  HITTimerApp.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI
import WatchConnectivity
import SwiftData

@main
struct HITTimer_Watch_AppApp: App {
    @StateObject private var workoutManager = WorkoutManager()
    @StateObject private var intervaltimer = IntervalTimer()
    @StateObject private var wcmanager = WatchConnectManager()
    @StateObject private var datamanager = DataManager()
    
    @Environment(\.scenePhase) private var newPhase
    
    init() {
        assert(WCSession.isSupported(), "this requres watch connectivity support")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutManager)
                .environmentObject(intervaltimer)
                .onChange(of: newPhase){ newPhase in
                    switch newPhase {
                    case .background : print("background")
                    case .inactive : print("inactive")
                    default: break
                    }
                }
        }
        .modelContainer(datamanager.container!)
    }
}
