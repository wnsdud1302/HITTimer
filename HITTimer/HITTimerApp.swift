//
//  HITTimerApp.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI
import UIKit
import WatchConnectivity
import UserNotifications
import BackgroundTasks

@main
struct HITTimerApp: App {
    
    @Environment(\.scenePhase) private var phase
    
    @StateObject var datamanager = DataManager.shared
    @StateObject var intervaltimer = IntervalTimer.shared
    @StateObject var wcmanager = WatchConnectManager()
    
    
        
    init(){
        let notification = UNUserNotificationCenter.current()
        
        notification.requestAuthorization(options: [.alert, .badge, .sound]){ granted, error in
            if granted{
                print("success")
            } else{
                print(error as Any)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(datamanager)
                .environmentObject(intervaltimer)
                .environmentObject(wcmanager)
        }
        .modelContainer(datamanager.container!)
    }
    
}
