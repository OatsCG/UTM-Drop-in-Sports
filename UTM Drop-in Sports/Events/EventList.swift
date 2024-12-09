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
                SavedEvents()
                ForEach($categoryParser.groupedEvents.days, id: \.date) { $day in
                    EventDaySection(day: $day)
                }
            }
        }
    }
}

struct EventDaySection: View {
    @Binding var day: DayEvents
    @State var isExpanded: Bool = true
    var body: some View {
        if #available(iOS 17.0, *) {
            Section(isExpanded: $isExpanded) {
                DynamicGridViewEC(day: $day)
//                ForEach($day.events, id: \.id) { $event in
//                    EventCard(event: $event)
//                        .transition(.blurReplace)
//                }
            } header: {
                EventDayHeader(isExpanded: $isExpanded, day: day)
            }
        } else {
            Section(header: EventDayHeader(isExpanded: $isExpanded, day: day)) {
                ForEach($day.events, id: \.id) { $event in
                    EventCard(event: $event)
                }
            }
        }
    }
}

@available(iOS 17.0, *)
struct DynamicGridViewEC: View {
    @Binding var day: DayEvents
    
    let minCellWidth: CGFloat = 350
    let maxCellWidth: CGFloat = 400
    
    @State var columns: [GridItem] = [.init(spacing: 10)]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach($day.events, id: \.id) { $event in
                EventCard(event: $event)
//                    .transition(.blurReplace)
                    .frame(minHeight: 150)
                    .lineLimit(1)
            }
        }
        .overlay {
            GeometryReader { geometry in
                Rectangle().fill(.clear)
                    .onAppear {
                        updateColumns(geometry.size.width)
                    }
                    .onChange(of: geometry.size.width) { newValue in
                        updateColumns(geometry.size.width)
                    }
            }
        }
    }
    func updateColumns(_ geowidth: CGFloat) {
        let totalWidth: CGFloat = geowidth
        let numberOfColumns: Int = max(1, Int(totalWidth / minCellWidth))
        let adjustedColumns: Int = Int(totalWidth / maxCellWidth) >= numberOfColumns ? numberOfColumns : max(1, numberOfColumns - 1)
        
        let gridItems: [GridItem] = Array(repeating: .init(spacing: 10), count: adjustedColumns)
        self.columns = gridItems
    }
}


struct EventDayHeader: View {
    @Binding var isExpanded: Bool
    var day: DayEvents
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text(relativeDateString(day.date))
                                .font(.title.bold())
                            Spacer()
                            if #available(iOS 17.0, *) {
                                Image(systemName: isExpanded ? "chevron.up.circle" : "chevron.down.circle")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
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
                if #available(iOS 17.0, *) {
                    Rectangle()
                        .strokeBorder(.quinary, lineWidth: 1)
                } else {
                    Rectangle()
                        .strokeBorder(.clear, lineWidth: 1)
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
