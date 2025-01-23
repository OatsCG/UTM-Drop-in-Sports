//
//  NextSessionWidgetLiveActivity.swift
//  NextSessionWidget
//
//  Created by Charlie Giannis on 2025-01-22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NextSessionWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NextSessionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NextSessionWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension NextSessionWidgetAttributes {
    fileprivate static var preview: NextSessionWidgetAttributes {
        NextSessionWidgetAttributes(name: "World")
    }
}

extension NextSessionWidgetAttributes.ContentState {
    fileprivate static var smiley: NextSessionWidgetAttributes.ContentState {
        NextSessionWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NextSessionWidgetAttributes.ContentState {
         NextSessionWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NextSessionWidgetAttributes.preview) {
   NextSessionWidgetLiveActivity()
} contentStates: {
    NextSessionWidgetAttributes.ContentState.smiley
    NextSessionWidgetAttributes.ContentState.starEyes
}
