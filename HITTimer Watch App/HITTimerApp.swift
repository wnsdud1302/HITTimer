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
    @StateObject private var datamanager = DataManager.shared
    
    @Environment(\.scenePhase) private var newPhase
    
    init() {
        assert(WCSession.isSupported(), "this requres watch connectivity support")
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                TimerListView()
                }
                .sheet(isPresented: $workoutManager.showingSummaryView, content: {
                    SummaryView()
                })
        }
        .environmentObject(workoutManager)
        .environmentObject(intervaltimer)
        .environmentObject(datamanager)
        .modelContainer(datamanager.container!)
    }
}
