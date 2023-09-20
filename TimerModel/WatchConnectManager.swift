//
//  WatchConnectManager.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/20.
//

import Foundation
import WatchConnectivity

class WatchConnectManager:NSObject, ObservableObject{
    
    let datanamager = DataManager.shared
    
    var session: WCSession?
    
    override init() {
        super.init()
        let session = WCSession.default
        session.delegate = self
        session.activate()
        self.session = session
    }
    
    func sendTimerData(which data: TimerData){
        do{
            try session?.updateApplicationContext(["totaltime": data.totaltime, "wotime": data.wotime, "rstime": data.rstime, "sets": data.sets])
        } catch {
            print(error)
        }
    }
}

#if os(iOS)
extension WatchConnectManager: WCSessionDelegate{
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}

#elseif os(watchOS)
extension WatchConnectManager: WCSessionDelegate{
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            let totaltime = applicationContext["totaltime"] as! Int
            let wotime = applicationContext["wotime"] as! Int
            let rstime = applicationContext["rstime"] as! Int
            let sets = applicationContext["sets"] as! Int
            let new = TimerData(totaltime: totaltime, wotime: wotime, rstime: rstime, sets: sets)
            self.datanamager.context?.insert(new)
        }
    }
}

#endif
