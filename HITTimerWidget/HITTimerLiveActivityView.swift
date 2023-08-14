//
//  HITTimerLiveActivityView.swift
//  HITTimer
//
//  Created by 박준영 on 2023/08/11.
//

import SwiftUI

struct HITTimerLiveActivityView: View {
    var progress: CGFloat
    var timeRemain: Int
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .stroke(Color(red: 0.3, green: 0.8, blue: 0.5).opacity(0.5), lineWidth: 10)
                Image(systemName: "figure.run.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 75))
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color(red: 0.3, green: 0.8, blue: 0.5), lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)
            }
            .frame(height: 90)
            .padding(.trailing, 10)
            
            Text(secondsToMS(timeRemain > 0 ? timeRemain : 0))
                .frame(width: 220)
                .font(.system(size: 50))
                .foregroundColor(.white)
        }
    }
    func secondsToMS(_ seconds: Int) -> String{
        return "\((seconds % 3600) / 60)분 \((seconds % 3600) % 60)초"
    }
}

struct HITTimerLiveActivityView_Previews: PreviewProvider {
    static var previews: some View {
        HITTimerLiveActivityView(progress: 0.5, timeRemain: 3599)
    }
}
