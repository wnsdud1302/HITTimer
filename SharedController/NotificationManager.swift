//
//  NotificationManager.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/22.
//

import Foundation
import UserNotifications

class NotificationManager:NSObject, ObservableObject{
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            notificationCenter.requestAuthorization(options: options) { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("SUCCESS")
                }
            }
        }
#if os(iOS)
    func sendNotification(when time: Int){
        let content = UNNotificationContent()
    }
#endif
}


extension NotificationManager: UNUserNotificationCenterDelegate{
    
}
