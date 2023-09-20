//
//  TimerView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/10.
//

import SwiftUI


struct TimerView: View {
    
    @EnvironmentObject var intervaltimer: IntervalTimer
    @ObservedObject var liveActivity = TimerLiveActivity.shared
    
    
    @State var timeRemain = 0
    @State var pause = false
    
    @Binding var start: Bool
    
    var body: some View {
        VStack{
            ZStack(alignment: .leading){
                
                Rectangle()
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.8))
                    .frame(width:350 * (Double((timeRemain > 0) ? timeRemain : 0) / (Double(intervaltimer.timers.first ?? 2) - 1)), height: 50)
                    .cornerRadius(15)
                    .animation(.linear(duration: 1), value: timeRemain)
                
                Rectangle()
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.8, opacity: 0.6))
                .frame(width: 350, height: 50)
                .cornerRadius(15)
                
            }
                
            Text(intervaltimer.secondsToHMS(timeRemain))
                    .font(.system(size: 50))
            
            HStack{
                Button(action: {
                    pause = !pause
                }){
                    ZStack{
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.orange)
                        Image(systemName: pause ? "play.fill" : "pause.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 50))
                    }
                }
                .padding(.trailing, 150)
                Button(action: {
                    intervaltimer.time.upstream.connect().cancel()
                    intervaltimer.timers.removeAll()
                    start = false
                    
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
        .transition(.move(edge: .bottom))
        .onAppear{
            intervaltimer.timeRemain = intervaltimer.timers.first! - 1
            intervaltimer.startTimers()
            liveActivity.onLiveActivity()
            liveActivity.timerTest()
        }
        .onDisappear{
            intervaltimer.stopTimers()
            liveActivity.offLiveActivity()
        }
        .onChange(of: pause){
            if $0 {
                intervaltimer.stopTimers()
            }else{
                intervaltimer.startTimers()
            }
        }
        .onReceive(intervaltimer.$timeRemain){
            print($0)
            timeRemain = $0
            if $0 < 3{
                if $0 == 0 {
                    HapticFeedback.shared.play(.heavy)
                    HapticFeedback.shared.notification(.success)
                }
                HapticFeedback.shared.play(.medium)
            }

        }
        .onChange(of: intervaltimer.timers.isEmpty){
            if $0 {
                start = false
                liveActivity.offLiveActivity()
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(start: .constant(true))
    }
}
