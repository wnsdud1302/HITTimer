//
//  TimerLiveActivity.swift
//  ITTimer
//
//  Created by 박준영 on 2023/08/11.
//

import SwiftUI
import ActivityKit
import Combine

class TimerLiveActivity: ObservableObject{
    
    static let shared = TimerLiveActivity()
    
    var intervaltimer = IntervalTimer.shared
    
    private var cancellable: Set<AnyCancellable> = Set()
    
    private var activity: Activity<HITTimerWidgetAttributes>?
    
    
    func onLiveActivity(){
        print("on")
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attribute = HITTimerWidgetAttributes(name: "test")

        let state = ActivityContent<HITTimerWidgetAttributes.ContentState>(state: HITTimerWidgetAttributes.ContentState(progress: 0, timeRemain: 0), staleDate: nil)
        do{
            activity = try Activity.request(attributes: attribute, content: state)
            } catch {
            //print(error)
        }
    }
    
    func offLiveActivity(){
        Task{
            print("off")
            
            await activity?.end(activity?.content ,dismissalPolicy: .immediate)
            cancellable.removeAll()
        }
    }
    
    func timerTest(){
        intervaltimer.$timeRemain.sink{ [self] in
            
            let timeRemain = $0
            
            let progress = CGFloat($0) / (CGFloat(intervaltimer.timers.first ?? 2) - 1)
            
            Task {
                let newState = ActivityContent<HITTimerWidgetAttributes.ContentState>(state: HITTimerWidgetAttributes.ContentState(progress: progress, timeRemain: timeRemain), staleDate: nil)
                //print("newState value \(newState.state.value)")
                await activity?.update(newState)
            }
        }
        .store(in: &cancellable)
    }
}
