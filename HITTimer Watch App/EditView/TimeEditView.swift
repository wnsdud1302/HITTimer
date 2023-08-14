//
//  TimeEditView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/08/14.
//

import SwiftUI

struct TimeEditView: View {
    
    let array = Array<Int>(1...10)
    
    @State var selected = 0
    
    var body: some View {
        VStack{
            Picker("time", selection: $selected){
                ForEach(array, id: \.self){
                    Text("\($0)")
                }
            }
        }
    }
}

#Preview {
    TimeEditView()
}
