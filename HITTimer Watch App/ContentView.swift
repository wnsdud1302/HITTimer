//
//  ContentView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var intervaltimer = intervalTimer.shared
    @State var time = 0
    var body: some View {
        TimeEditView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
