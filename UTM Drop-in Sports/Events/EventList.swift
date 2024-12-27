//
//  EventList.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventList: View {
    @EnvironmentObject var categoryParser: CategoryParser
    
    let minCellWidth: CGFloat = 380
    let maxCellWidth: CGFloat = 450
    
    @State var columnCount: Int = 1
    @State var columns: [GridItem] = [.init(spacing: 10)]
    @State var cellWidth: CGFloat?
    
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
            ZStack {
                LazyVStack(alignment: .leading) {
                    SavedEvents()
                    // TODO: INDEX ERROR IS HEREEE
                    // AHHHHHH
                    //
                    ForEach($categoryParser.groupedEvents.days, id: \.date) { $day in
                        EventDaySection(day: $day, columnCount: $columnCount, columns: $columns, cellWidth: $cellWidth)
                    }
                }
                GeometryReader { geometry in
                    Rectangle().fill(.clear)
                        .onAppear {
//                            updateColumns(geometry.size.width)
                        }
//                        .onChange(of: geometry.size.width) { newValue in
//                            updateColumns(geometry.size.width)
//                        }
                }
            }
        }
    }
    
    func updateColumns(_ geowidth: CGFloat) {
        Task.detached {
            let totalWidth: CGFloat = geowidth
            let numberOfColumns: Int = max(1, Int(totalWidth / minCellWidth))
            let adjustedNumColumns: Int = Int(totalWidth / maxCellWidth) >= numberOfColumns ? numberOfColumns : max(1, numberOfColumns - 1)
            
            let gridItems: [GridItem] = Array(repeating: .init(spacing: 10), count: adjustedNumColumns)
            
            let adjustedTotalWidth: CGFloat = totalWidth - CGFloat((10 * (adjustedNumColumns - 1)))
            
            let cellWidth: CGFloat = adjustedTotalWidth / CGFloat(adjustedNumColumns)
            
            
            await MainActor.run {
                self.categoryParser.columnCount = adjustedNumColumns
                self.columns = gridItems
                self.cellWidth = cellWidth
//                self.categoryParser.updateDisplayEvents(maxEvents: 50)
            }
        }
    }
}

struct EventDaySection: View {
    @Binding var day: DayEvents
    @State var isExpanded: Bool = true
    
    @Binding var columnCount: Int
    @Binding var columns: [GridItem]
    @Binding var cellWidth: CGFloat?
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Section(isExpanded: $isExpanded) {
//                DynamicGridViewEC(day: $day, columnCount: $columnCount, columns: $columns, cellWidth: $cellWidth)
                ForEach($day.events, id: \.id) { $event in
                    EventCard(event: $event)
                        .transition(.blurReplace)
                }
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
    
    @Binding var columnCount: Int
    @Binding var columns: [GridItem]
    @Binding var cellWidth: CGFloat?
    
    var body: some View {
        DynamicGridForEach(columnCount: $columnCount, cellWidth: $cellWidth, day: $day)
    }
}

@available(iOS 17.0, *)
struct DynamicGridForEachLazy: View {
    @Binding var columnCount: Int
    @Binding var cellWidth: CGFloat?
    @Binding var day: DayEvents
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(spacing: 10), count: columnCount)) {
            ForEach($day.events, id: \.id) { $event in
                EventCard(event: $event)
                    .transition(.blurReplace)
//                    .frame(minHeight: 150)
            }
        }
    }
}

@available(iOS 17.0, *)
struct DynamicGridForEach: View {
    @Binding var columnCount: Int
    @Binding var cellWidth: CGFloat?
    @Binding var day: DayEvents
    
    var body: some View {
        // TODO: CRASH HERE - LazyVStack crashes (NO ERROR CODE), but VStack causes lag!?
        // Crash happens rarely, but lag happens everywhere (window size change, category change, etc). Which do I prioritize??
        LazyVStack(alignment: .leading, spacing: 10) {
            ForEach($day.rows, id: \.id) { $row in
                DGFERow(row: $row, cellWidth: $cellWidth)
                    .transition(.blurReplace)
            }
        }
    }
}

@available(iOS 17.0, *)
struct DGFERow: View {
    @Binding var row: DynamicRow
    @Binding var cellWidth: CGFloat?
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach($row.events, id: \.id) { $event in
                EventCard(event: $event)
                    .transition(.blurReplace)
                    .frame(maxWidth: cellWidth, idealHeight: 150)
            }
        }
    }
}


struct EventDayHeader: View {
    @Environment(\.colorScheme) private var colorScheme
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
                    if colorScheme == .dark {
                        Rectangle()
                            .fill(.white.opacity(0.05))
                    } else {
                        Rectangle()
                            .strokeBorder(.quinary, lineWidth: 1)
                    }
                } else {
                    if colorScheme == .dark {
                        Rectangle()
                            .fill(.white.opacity(0.05))
                    } else {
                        Rectangle()
                            .strokeBorder(.clear, lineWidth: 1)
                    }
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
