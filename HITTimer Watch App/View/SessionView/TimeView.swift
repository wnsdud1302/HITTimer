//
//  TimeView.swift
//  HITTimer Watch App
//
//  Created by 박준영 on 2023/09/23.
//

import SwiftUI

struct TimeView: View {
    
    @State private var timerFormatter = ElapsedTimeFormatter()
    
    var time : TimeInterval = 0

    var showSubseconds: Bool = true
    
    var body: some View {
        Text(NSNumber(value: time), formatter: timerFormatter)
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
    var showSubseconds = true

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


