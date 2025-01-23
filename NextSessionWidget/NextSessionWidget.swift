//
//  NextSessionWidget.swift
//  NextSessionWidget
//
//  Created by Charlie Giannis on 2025-01-22.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), event: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, event: nil)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let categoryParser: CategoryParser = await CategoryParser()
        let events: [Event] = categoryParser.events
        let sportToRun: String? = configuration.category?.rawValue
        
        let nextEvent: Event? = events.first(where: { $0.sortCategory == sportToRun })
        if let nextEvent {
            // add entries every hour until the event end date
            let end_date: Date = nextEvent.relativeTimeDate.endDate
            let hours_until_end_date: Int = Calendar.current.dateComponents([.hour], from: Date(), to: end_date).hour!
            for hourOffset in 0 ... max(hours_until_end_date, 10) {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: Date())!
                let entry = SimpleEntry(date: entryDate, configuration: configuration, event: nextEvent)
                entries.append(entry)
            }
        } else {
            let entry = SimpleEntry(date: Date(), configuration: configuration, event: nil)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let event: Event?
}

struct NextSessionWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Group {
            if let event = entry.event {
                NSWView(event: event)
            } else {
                Text("No sessions to show.")
                    .foregroundStyle(.blueUTM.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct NSWView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if event.lgbt {
                    SymbolImage(event.symbol)
                        .font(.largeTitle.weight(.regular))
                        .foregroundStyle(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center))
                        .overlay {
                            SymbolImage(event.symbol)
                                .font(.largeTitle.weight(.regular))
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .opacity(colorScheme == .dark ? 0.25 : 0.15)
                            
                        }
                } else {
                    SymbolImage(event.symbol)
                        .font(.largeTitle.weight(.regular))
                        .foregroundStyle(event.womens ? .pinkUTM : .blueUTM)
                }
                Spacer()
            }
            Text(event.sortCategory)
                .font(.title3 .bold())
                .foregroundStyle(.blueUTM)
                .lineLimit(1)
            Text(event.title)
                .font(.caption2 .bold())
                .foregroundStyle(.blueUTM.secondary)
                .lineLimit(1)
            Spacer()
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .symbolRenderingMode(.hierarchical)
                Text(event.venue)
            }
                .font(.caption .bold())
                .padding(.bottom, 1)

            if event.relativeTimeDate.isOngoing {
                HStack {
                    if #available(iOS 18.0, *) {
                        Image(systemName: "record.circle")
                            .font(.caption2)
                            .symbolEffect(.pulse .byLayer, options: .repeat(.continuous))
                    } else {
                        Image(systemName: "record.circle")
                            .font(.caption2)
                    }
                    Text("Ongoing")
                }
                .font(.caption)
                .foregroundStyle(.green)
            } else {
                HStack {
                    if event.relativeTimeDate.timeLeftString == "" {
                        HStack {
                            if #available(iOS 16.0, *) {
                                Image(systemName: event.relativeTimeDate.daySymbol)
                                    .foregroundStyle(event.relativeTimeDate.daySymbolColor.gradient)
                            } else {
                                Image(systemName: event.relativeTimeDate.daySymbol)
                                    .foregroundStyle(event.relativeTimeDate.daySymbolColor)
                            }
                            Text(relativeDaysUntilString(event.relativeTimeDate.startDate))
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text(event.relativeTimeDate.timeLeftString)
                            .foregroundStyle(event.relativeTimeDate.timeLeftString == "Soon" ? .orange : .secondary)
                    }
                }
                .font(.caption2)
                .foregroundStyle(.primary)
            }
        }
    }
}

func relativeDaysUntilString(_ date: Date) -> String {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let targetDate = calendar.startOfDay(for: date)
    
    guard let daysDifference = calendar.dateComponents([.day], from: today, to: targetDate).day else {
        return ""
    }
    
    if daysDifference > 1 && daysDifference <= 7 {
        return "In \(daysDifference) days"
    } else {
        return ""
    }
}




struct NextSessionWidget: Widget {
    let kind: String = "NextSessionWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            NextSessionWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.category = .mindbody
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.category = .soccer
        return intent
    }
}

#Preview(as: .systemSmall) {
    NextSessionWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, event: nil)
    SimpleEntry(date: .now, configuration: .starEyes, event: nil)
}
