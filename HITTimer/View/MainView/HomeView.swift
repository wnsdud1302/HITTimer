//
//  HomeView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/09/20.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var intervaltimer: IntervalTimer
    @EnvironmentObject var datamanage: DataManager
    
    @State var start = false
    
    @State var totaltime = 0
    
    var body: some View {
        NavigationStack{
            TabView{
                TimerSettingView(start: $start, totalTime: $totaltime)
                    .tabItem {
                        Image(systemName: "timer")
                            .foregroundStyle(.blue)
                        Text("settting")
                    }
                TimerSavedView(start: $start, totalTime: $totaltime)
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                        Text("list")
                    }
            }
            .navigationDestination(isPresented: $start){
                TimerView(totaltime: $totaltime, start: $start)
                    .navigationBarBackButtonHidden()
                    .toolbar(.hidden)
            }

        }
    }
}


