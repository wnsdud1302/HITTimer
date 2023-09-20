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
    var body: some View {
        if !start{
            TabView{
                TimerSettingView(start: $start)
                    .tabItem {
                        Image(systemName: "timer")
                            .foregroundStyle(.blue)
                        Text("settting")
                    }
                TimerSavedView(start: $start)
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                        Text("list")
                    }
            }
        } else {
            TimerView(start: $start)
        }
    }
}

#Preview {
    HomeView()
}
