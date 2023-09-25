//
//  TimeView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/23.
//

import SwiftUI

struct TimeView: View {
    
    @EnvironmentObject var intervalTimer: IntervalTimer
    
    
    @State private var timerFormatter = ElapsedTimeFormatter()

    @Binding var showSubseconds:Bool
    
    var body: some View {
        Text(NSNumber(value: intervalTimer.timeRemain), formatter: timerFormatter)
            .onChange(of: showSubseconds){
                timerFormatter.showSubseconds = !timerFormatter.showSubseconds
            }
    }
}

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = false

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }

        if showSubseconds {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }

        return formattedString
    }
}


