//
//  HITTimerWidgetLiveActivity.swift
//  HITTimerWidget
//
//  Created by 박준영 on 2023/08/11.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HITTimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var progress: CGFloat
        var timeRemain: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HITTimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HITTimerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HITTimerLiveActivityView(progress: context.state.progress, timeRemain: context.state.timeRemain)
                .activityBackgroundTint(Color(red: 0.6, green: 0.3, blue: 0.8, opacity: 0.7))
            .activitySystemActionForegroundColor(.white)
            .frame(height: 130)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text(String(context.state.timeRemain))
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct HITTimerWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = HITTimerWidgetAttributes(name: "Me")
    static let contentState = HITTimerWidgetAttributes.ContentState(progress: 0.5, timeRemain: 3599)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
