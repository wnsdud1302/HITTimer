//
//  HITTimerWidgetBundle.swift
//  HITTimerWidget
//
//  Created by 박준영 on 2023/08/11.
//

import WidgetKit
import SwiftUI

@main
struct HITTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        HITTimerWidget()
        HITTimerWidgetLiveActivity()
    }
}
