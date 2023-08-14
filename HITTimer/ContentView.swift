//
//  ContentView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var intervaltimer = intervalTimer.shared
    
    @State var WOmin = 0
    @State var WOsec = 0
    
    @State var RSTmin = 0
    @State var RSTsec = 0
    
    @State var sets = 1
    
    @State var start = false
    
    var body: some View {
        VStack{
            if !start {
                NavigationStack{
                    VStack {
                        Spacer()
                        Text(totalTime())
                            .font(.system(size: 50))
                        Spacer()
                        Button(action: {
                            intervaltimer.addTimers(totalSec(0, WOmin, WOsec), rst: totalSec(0, RSTmin, RSTsec), sets)
                            start = true
                        }){
                            ZStack{
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.red)
                                Image(systemName: "play.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 5)
                        SetEditView(sets: $sets)
                            .frame(width: 350, height: 100)
                            .background(Color(red: 0.5, green: 1, blue: 0.7))
                            .cornerRadius(15)
                        
                        NavigationLink(destination: TimerEditView(minute: $WOmin, second: $WOsec)){
                            VStack{
                                Text("운동시간")
                                    .font(.system(size: 50))
                                    .foregroundColor(.black)
                                Text("\(WOmin) 분 \(WOsec) 초")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 350)
                            .background(Color(red: 1, green: 0.7, blue: 0.3))
                            .cornerRadius(15)
                        } // 운동시간
                        .padding(.bottom, 5)
                        NavigationLink(destination: TimerEditView(minute: $RSTmin, second: $RSTsec)){
                            VStack{
                                Text("휴식시간")
                                    .font(.system(size: 50))
                                    .foregroundColor(.black)
                                Text("\(RSTmin) 분 \(RSTsec) 초")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 350)
                            .background(Color(red: 0.3, green: 0.7, blue: 1))
                            .cornerRadius(15)
                        } // 휴식시간
                    }
                    .padding()
                }
                .transition(.move(edge: .bottom))
            }
            else{
                TimerView(start: $start)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.linear(duration: 0.2), value: start)
    }
}

extension ContentView{
    func secondsToHMS(_ seconds: Int) -> String{
        return "\(seconds / 3600)시간 \((seconds % 3600) / 60)분 \((seconds % 3600) % 60)초"
    }
    func minuteToSec(_ min: Int) -> Int{
        return min * 60
    }
    func hourToSec(_ hour: Int) -> Int {
        return hour * 3600
    }
    
    func totalSec(_ hours: Int, _ minutes: Int, _ seconds: Int) -> Int{
        return hourToSec(hours) + minuteToSec(minutes) + seconds
    }
    func totalTime() -> String{
        let wo = totalSec(0, WOmin, WOsec)
        let rst = totalSec(0, RSTmin, RSTsec)
        let total = (wo + rst) * sets
        return secondsToHMS(total)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
