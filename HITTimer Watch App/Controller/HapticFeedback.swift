//
//  HapticFeedback.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/24.
//

import Foundation
import WatchKit

class HapticFeedback: ObservableObject{
    static let shared = HapticFeedback()
    
    func sendFeedBack(_ type: WKHapticType){
        WKInterfaceDevice.current().play(type)
    }
}
