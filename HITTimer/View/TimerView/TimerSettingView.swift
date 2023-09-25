//
//  ContentView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/09.
//

import SwiftUI
import UserNotifications

struct TimerSettingView: View {
    
    @EnvironmentObject var intervaltimer: IntervalTimer
    @EnvironmentObject var datamanager: DataManager
    @EnvironmentObject var wcmanager: WatchConnectManager
    
    
    @State var WOmin = 0
    @State var WOsec = 0
    
    @State var RSTmin = 0
    @State var RSTsec = 0
    
    @State var sets = 1
    
    @Binding var start:Bool
    @Binding var totalTime: Int
    
    let notificaiton = UNUserNotificationCenter.current()
    
    var body: some View {
        VStack{
                NavigationStack{
                    VStack {
                        Spacer()
                        Text(secondsToHMS(getTotalTime()))
                            .font(.system(size: 50))
                        Spacer()
                        HStack{
                            Button(action: {
                                totalTime = getTotalTime()
                                intervaltimer.addTimers(totalSec(0, WOmin, WOsec), totalSec(0, RSTmin, RSTsec), sets)
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
                            .padding(.trailing, 90)
                            Button(action:{
                                if getTotalTime() != 0{
                                    datamanager.insertData(totaltime: getTotalTime(), wotime: totalSec(0, WOmin, WOsec), rstime: totalSec(0, RSTmin, RSTsec), sets: sets)
                                    wcmanager.sendTimerData(which: TimerData(totaltime: getTotalTime(), wotime: totalSec(0, WOmin, WOsec), rstime: totalSec(0, RSTmin, RSTsec), sets: sets))
                                }
                            }){
                                ZStack{
                                    Circle()
                                        .frame(width: 100)
                                        .foregroundColor(Color(red: 0.5, green: 0.7, blue: 0.7))
                                    Image(systemName: "applewatch.watchface")
                                        .font(.system(size: 65))
                                        .foregroundStyle(.white)
                                }
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
                .transition(.push(from: .trailing))
            }// navigationStack
        }// body
}//


extension TimerSettingView{
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
    
    func getTotalTime()-> Int{
        let wo = totalSec(0, WOmin, WOsec)
        let rst = totalSec(0, RSTmin, RSTsec)
        let total = (wo + rst) * sets
        return total
    }
}

