//
//  ContentView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var body: some View {
        Text("hello world!")
    }
}

#Preview{
    ContentView()
}
