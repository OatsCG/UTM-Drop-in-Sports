//
//  EventList.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventList: View {
    @EnvironmentObject var categoryParser: CategoryParser
    var body: some View {
        if categoryParser.events.isEmpty {
            VStack {
                Image(systemName: "flag.2.crossed")
                    .foregroundStyle(.secondary)
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("No events found.")
                    .font(.title2 .bold())
                Text("Try selecting less filters.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
        } else {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                ForEach(categoryParser.groupedEvents.days, id: \.date) { day in
                    Section(header: EventDayHeader(day: day)) {
                        ForEach(day.events, id: \.id) { event in
                            if #available(iOS 17.0, *) {
                                EventCard(event: event)
                                    .transition(.blurReplace)
                            } else {
                                EventCard(event: event)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct EventDayHeader: View {
    var day: DayEvents
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(relativeDateString(day.date))
                        .font(.title.bold())
                    Spacer()
                }
                if relativeDaysUntilString(day.date) != "" {
                    HStack {
                        Text(relativeDaysUntilString(day.date))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 10)
        }
        .background {
            Group {
                if #available(iOS 16.0, *) {
                    Rectangle()
                        .strokeBorder(.quinary, lineWidth: 1)
                } else {
                    Rectangle()
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
            }
                .background(Rectangle().fill(.background))
                .ignoresSafeArea()
                .shadow(color: .black.opacity(0.05), radius: 5, y: -5)
        }
    }
}

func relativeDateString(_ date: Date) -> String {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let targetDate = calendar.startOfDay(for: date)
    
    if calendar.isDate(today, inSameDayAs: targetDate) {
        return "Today"
    } else if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today), calendar.isDate(tomorrow, inSameDayAs: targetDate) {
        return "Tomorrow"
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: date)
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


#Preview {
    ContentView()
}
