//
//  HITTimerApp.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI


@main
struct HITTimerApp: App {
    
    @Environment(\.scenePhase) private var phase
    
    @StateObject var datamanager = DataManager.shared
    @StateObject var intervaltimer = IntervalTimer.shared
    @StateObject var wcmanager = WatchConnectManager()
    @StateObject var player = AudioPlayer.shared
    
    var body: some Scene {
        WindowGroup {
                HomeView()
                    .environmentObject(datamanager)
                    .environmentObject(intervaltimer)
                    .environmentObject(wcmanager)
                    .environmentObject(player)
        }
        .modelContainer(datamanager.container!)
    }
}
