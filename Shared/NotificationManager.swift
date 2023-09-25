//
//  NotificationManager.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/22.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject{
    static let shared = NotificationManager()
    
    func requestAuthorization() {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("SUCCESS")
                }
            }
        }
}
