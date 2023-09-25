//
//  HapticFeedbacks.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/10.
//

import Foundation
import UIKit

class HapticFeedback {
    static let shared = HapticFeedback()
    
    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle){
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notification(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType){
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
