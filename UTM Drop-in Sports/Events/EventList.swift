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
            VStack(alignment: .leading) {
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
    
    @State var columnCount: Int = 1
    @State var columns: [GridItem] = [.init(spacing: 10)]
    @State var cellWidth: CGFloat?
    
    var body: some View {
        ZStack {
            DynamicGridForEach(columnCount: $columnCount, cellWidth: $cellWidth, day: $day)
            GeometryReader { geometry in
                Rectangle().fill(.red.opacity(0.4))
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
        print("UPDATING COLUMNS")
        Task.detached {
            let totalWidth: CGFloat = geowidth
            let numberOfColumns: Int = max(1, Int(totalWidth / minCellWidth))
            let adjustedColumns: Int = Int(totalWidth / maxCellWidth) >= numberOfColumns ? numberOfColumns : max(1, numberOfColumns - 1)
            
            let gridItems: [GridItem] = Array(repeating: .init(spacing: 10), count: adjustedColumns)
            
//            let adjWidth: CGFloat = totalWidth - (10 * (CGFloat(adjustedColumns) - 1))
            
            let cellWidth: CGFloat = totalWidth / CGFloat(adjustedColumns) - 10
            
            await MainActor.run {
                self.columnCount = adjustedColumns
                self.columns = gridItems
                self.cellWidth = cellWidth
            }
        }
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
                    .frame(minHeight: 150)
                    .lineLimit(1)
            }
        }
    }
}

@available(iOS 17.0, *)
struct DynamicGridForEach: View {
    @Binding var columnCount: Int
    @Binding var cellWidth: CGFloat?
    @Binding var day: DayEvents
    
    @State var rows: [DynamicRow] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach($rows, id: \.self) { $row in
                DGFERow(row: $row, cellWidth: $cellWidth)
//                .transition(.blurReplace)
            }
        }
        .onAppear {
            self.updateRows()
        }
        .onChange(of: columnCount) { newValue in
            self.updateRows()
        }
        .onChange(of: day) { newValue in
            self.updateRows()
        }
        .onChange(of: day.events) { newValue in
            self.updateRows()
        }
    }
    
    private func updateRows() {
        print("UDPATING ROWS...")
        var rows: [DynamicRow] = []
        for rowIndex in 0..<rowsCount() {
            // create DynamicRow with this row's events
            var thisRowsEvents: [Event] = []
            let startIndex = rowIndex * columnCount
            let endIndex = startIndex + columnCount
            for eventIndex in startIndex..<endIndex {
                guard eventIndex < day.events.count else { break }
                thisRowsEvents.append(day.events[eventIndex])
            }
            rows.append(.init(events: thisRowsEvents))
        }
        print("WRITING!")
        withAnimation {
            self.rows = rows
        }
    }
    
    private func rowsCount() -> Int {
        (day.events.count + columnCount - 1) / columnCount
    }
    
    private func eventAt(row: Int, column: Int) -> Binding<Event>? {
        let index = row * columnCount + column
        guard index < day.events.count else { return nil }
        return $day.events[index]
    }
}

@available(iOS 17.0, *)
struct DGFERow: View {
    @Binding var row: DynamicRow
    @Binding var cellWidth: CGFloat?
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach($row.events, id: \.self) { $event in
                EventCard(event: $event)
                    .transition(.blurReplace)
                    .frame(maxWidth: cellWidth, minHeight: 150)
                    .lineLimit(1)
            }
        }
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
