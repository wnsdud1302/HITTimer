//
//  TimerView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/10.
//

import SwiftUI


struct TimerView: View {
    
    @EnvironmentObject var intervaltimer : IntervalTimer
    @EnvironmentObject var player : AudioPlayer
        
    @Binding var totaltime: Int
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var start: Bool
    
    var body: some View {
        VStack{
            Text(intervaltimer.checkType())
                .font(.system(size: 90))
            TimerProgressView()
            Text(intervaltimer.secondsToHMS(intervaltimer.timeRemain))
                    .font(.system(size: 50))
            
            HStack{
                Button(action: {
                    intervaltimer.toggleTimer()
                }){
                    ZStack{
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.orange)
                        Image(systemName: intervaltimer.running ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 50))
                    }
                }
                .padding(.trailing, 150)
                Button(action: {
                    start = false
                    Task{
                        intervaltimer.timers.removeAll()
                    }
                    player.activeToggle()
                    
                }){
                    ZStack{
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.orange)
                        Text("취소")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
            }
        }
        .modifier(settingTimer(totaltime: $totaltime))
    }
    
    
}

struct TimerProgressView: View {
    @EnvironmentObject var intervaltimer: IntervalTimer
    
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.8))
                .frame(width:350 * getProgress(denominator: intervaltimer.timers.first, numerator: intervaltimer.timeRemain), height: 50)
                .cornerRadius(15)
                .animation(.linear(duration: checkAnimation() ? 0 : 1), value: intervaltimer.timeRemain)
            
            Rectangle()
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.8, opacity: 0.6))
            .frame(width: 350, height: 50)
            .cornerRadius(15)
        }
    }
    
    func getProgress(denominator: Int?, numerator: Int) -> CGFloat{
        guard denominator != nil else {
            return 0
        }
        
        let denominator = CGFloat((denominator ?? 2) - 1)
        let numerator = CGFloat(numerator >= 0 ? numerator : 1)
        
        return numerator / denominator
    }
    
    func checkAnimation() -> Bool{
        return intervaltimer.timers.first! - 1 == intervaltimer.timeRemain
    }
    
}

struct settingTimer: ViewModifier{
    
    @EnvironmentObject var intervaltimer : IntervalTimer
    @EnvironmentObject var player : AudioPlayer
    
    @Binding var totaltime: Int
    
    func body(content: Content) -> some View {
        content.onAppear{
            player.activeToggle()
            Task{
                let playItem = await player.mergeAudioFiles(totalTime: totaltime)
                player.makePlayer(file: playItem)
                intervaltimer.startTimers()
            }
            intervaltimer.timeRemain = intervaltimer.timers.first! - 1
        }
        .onDisappear{
            player.end()
        }
    }
}
