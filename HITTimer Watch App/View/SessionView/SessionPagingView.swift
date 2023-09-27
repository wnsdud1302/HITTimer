//
//  SessionPagingView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/21.
//

import SwiftUI
import WatchKit
import HealthKit

struct SessionPagingView: View {
    
    @EnvironmentObject var workoutmanager: WorkoutManager
    @EnvironmentObject var intervaltimer: IntervalTimer
    @EnvironmentObject var intervalTimerWithDate: IntervalTimerWithDate
    
    @Binding var activityType:HKWorkoutActivityType
    @State private var selection: Tab = .metrics
    
    @Binding var showView: Bool
    
    @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    
    
    
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection){
            ControlView().tag(Tab.controls)
            MetricView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationTitle(workoutmanager.session?.workoutConfiguration.activityType.name ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .onChange(of: workoutmanager.running){
            withAnimation{
                selection = .metrics
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        
        
        .onChange(of: isLuminanceReduced){
            withAnimation{
                selection = .metrics
            }
        }
        .modifier(endSessionPagingView(activityType: $activityType, showView: $showView))
        .modifier(SettingSessionPagingView(activityType: $activityType)) // settingView
    }
}


struct endSessionPagingView: ViewModifier{
    
    @EnvironmentObject var workoutmanager: WorkoutManager
    @EnvironmentObject var intervaltimer: IntervalTimer
    @EnvironmentObject var intervalTimerWithDate: IntervalTimerWithDate
    
    @Binding var activityType:HKWorkoutActivityType
    @Binding var showView: Bool
    
    
    func body(content: Content) -> some View {
        content
            .onChange(of: workoutmanager.showingSummaryView){ oldState, newState in
                if !newState{
                    showView = false
                }
            }
            .onChange(of: intervalTimerWithDate.endtimer){ oldState, newState in
                if newState && !oldState{
                    workoutmanager.endWorkout()
                }
            }
            
        
    }
    
}


struct SettingSessionPagingView: ViewModifier{
    
    @EnvironmentObject var workoutmanager: WorkoutManager
    @EnvironmentObject var intervaltimer: IntervalTimer
    @EnvironmentObject var intervalTimerWithDate: IntervalTimerWithDate
    
    @Binding var activityType:HKWorkoutActivityType
    
    func body(content: Content) -> some View {
        content
            .onAppear{
                if activityType == .traditionalStrengthTraining{
                    workoutmanager.startWorkout(workoutType: activityType, locationType: .indoor)
                } else {
                    workoutmanager.startWorkout(workoutType: activityType, locationType: .outdoor)
                }
//                intervaltimer.timeRemain = intervaltimer.timers.first! - 1
                intervalTimerWithDate.startTimer()
                print(intervalTimerWithDate.timers)
            }
    }
}
