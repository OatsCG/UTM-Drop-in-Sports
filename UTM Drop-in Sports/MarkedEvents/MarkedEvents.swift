//
//  MarkedEvents.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-10-05.
//

import SwiftUI
import ConfettiSwiftUI

struct SavedEvents: View {
    @AppStorage("isHidingSaveHint") var isHidingSaveHint: Bool = false
    @EnvironmentObject var categoryParser: CategoryParser
    @State var isExpanded: Bool = true
    var body: some View {
        VStack {
            if !categoryParser.savedOngoingEvents.isEmpty {
                if #available(iOS 17.0, *) {
                    Section(isExpanded: $isExpanded) {
                        ForEach($categoryParser.savedOngoingEvents, id: \.id) { $event in
                            EventCardActive(event: $event)
                                .transition(.blurReplace)
                        }
                    } header: {
                        SavedEventsHeader(isExpanded: $isExpanded)
                    }
                } else {
                    Section {
                        ForEach($categoryParser.savedOngoingEvents, id: \.id) { $event in
                            EventCardActive(event: $event)
                        }
                        .apply {
                            if #available(iOS 17.0, *) {
                                $0
                            } else {
                                $0.padding(.horizontal)
                            }
                        }
                    } header: {
                        SavedEventsHeader(isExpanded: $isExpanded)
                    }
                }
            }
            else {
                if isHidingSaveHint {
                    Divider()
                        .opacity(0)
//                        .onAppear {
//                            isHidingSaveHint = false
//                        }
                } else {
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        isHidingSaveHint = true
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.tertiary)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.top, 8)
                            .font(.callout)
                            Text("Save sessions to participate and earn medals!")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .padding(.bottom, 5)
                                .padding(.horizontal, 30)
                            Text("Active Sessions will show here. When a saved session ends, mark it as complete to collect your medal.")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .padding(.horizontal, 30)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 15)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    }
                    .padding(.bottom, 15)
                    .apply {
                        if #available(iOS 17.0, *) {
                            $0
                        } else {
                            $0.padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct SavedEventsHeader: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isExpanded: Bool
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
                            HStack {
                                Image(systemName: "bookmark")
                                Text("Active Sessions")
                            }
                            .font(.title.bold())
                            Spacer()
                            if #available(iOS 17.0, *) {
                                Image(systemName: isExpanded ? "chevron.up.circle" : "chevron.down.circle")
                                    .font(.title2)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 10)
            .apply {
                if #available(iOS 17.0, *) {
                    $0
                } else {
                    $0.padding(.horizontal)
                }
            }
        }
        .background {
            Group {
                if colorScheme == .dark {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.08),
                                    .white.opacity(0.05),
                                    .white.opacity(0.03),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
//                        .fill(.white.opacity(0.08))
                } else {
                    if #available(iOS 17.0, *) {
                        Rectangle()
                            .strokeBorder(.quinary, lineWidth: 1)
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



struct EventCardActive: View {
    @Binding var event: Event
    @State var showingSheet: Bool = false
    @Namespace var animation
    var body: some View {
        Button(action: {
            showingSheet = true
        }) {
            EventCardContentActive(event: $event)
                .apply {
                    if #available(iOS 18.0, *) {
                        $0.matchedTransitionSource(id: event.id, in: animation)
                    } else {
                        $0
                    }
                }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheet) {
            EventContentActive(showingSheet: $showingSheet, event: $event)
                .apply {
                    if #available(iOS 18.0, *) {
                        $0.navigationTransition(.zoom(sourceID: event.id, in: animation))
                    } else {
                        $0
                    }
                }
        }
    }
}

struct EventContentActive: View {
    @Binding var showingSheet: Bool
    @Binding var event: Event
    var body: some View {
        if event.relativeTimeDate.isEventOver {
            EventContent(showingSheet: $showingSheet, event: $event)
        } else {
            EventContent(showingSheet: $showingSheet, event: $event)
        }
    }
}

struct EventCardContentActive: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Binding var event: Event
    @State var showingMedalAcceptance: Bool = false
    @State var didAccept: Bool = false
    var body: some View {
        EventCardContentActiveBody(event: $event, showingMedalAcceptance: $showingMedalAcceptance)
            .sheet(isPresented: $showingMedalAcceptance) {
                print("dismissed! didAccept: \(didAccept)")
                if didAccept {
                    categoryParser.unsaveEvent(event: event)
                }
            } content: {
                if let $medal = $categoryParser.medalsCollected.first(where: { $0.category.wrappedValue == event.sortCategory }) {
                    MedalAcceptanceSheet(event: $event, showingMedalAcceptance: $showingMedalAcceptance, medal: $medal, didAccept: $didAccept)
                }
            }
    }
}

struct EventCardContentActiveBody: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Binding var event: Event
    @Binding var showingMedalAcceptance: Bool
    @State var isAboutToCloseEvent: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                SymbolImage(event.symbol)
                    .font(.title)
                Text(event.title)
                    .font(.title3 .bold())
                Spacer()
                if event.saved {
                    Image(systemName: "bookmark.fill")
                        .font(.title2)
                }
            }
            .foregroundStyle(.blueUTM)
            .padding(.bottom, 6)
            if event.relativeTimeDate.isEventOver {
                if !isAboutToCloseEvent {
                    Button(action: {
                        withAnimation {
                            isAboutToCloseEvent = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Close Session...")
                            Spacer()
                        }
                        .font(.headline .bold())
                        .foregroundStyle(.primary)
                        .padding(.vertical, 12)
                        .background {
                            if #available(iOS 17.0, *) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.blueUTMbg.opacity(0.8))
                                    .stroke(.tertiary, lineWidth: 1)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(.tertiary, lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(.blueUTMbg.opacity(0.8)))
                            }
                        }
                        .padding(.top, 20)
                    }
                    .buttonStyle(.plain)
                    
                } else {
                    HStack(spacing: 10) {
                        Button(action: {
                            participationCheckNo()
                        }) {
                            HStack {
                                Spacer()
                                Text("Remove")
                                Spacer()
                            }
                            .font(.headline .bold())
                            .foregroundStyle(.primary)
                            .padding(.vertical, 12)
                            .background {
                                if #available(iOS 17.0, *) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.blueUTMbg)
                                        .stroke(.tertiary, lineWidth: 1)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(.tertiary, lineWidth: 1)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(.blueUTMbg))
                                }
                            }
                            .padding(.top, 20)
                        }
                        .buttonStyle(.plain)
                        Button(action: {
                            participationCheckYes()
                        }) {
                            HStack {
                                Spacer()
                                Text("I Participated!")
                                Spacer()
                            }
                            .font(.headline .bold())
                            .foregroundStyle(.primary)
                            .padding(.vertical, 12)
                            .background {
                                if #available(iOS 17.0, *) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.blueUTMbg)
                                        .stroke(.tertiary, lineWidth: 1)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(.tertiary, lineWidth: 1)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(.blueUTMbg))
                                }
                            }
                            .padding(.top, 20)
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .symbolRenderingMode(.hierarchical)
                            Text(event.venue)
                        }
                        Spacer()
                    }
                    .font(.subheadline .bold())
                    .padding(.bottom, 6)
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
                                if #available(iOS 18.0, *) {
                                    Image(systemName: event.relativeTimeDate.daySymbol)
                                        .foregroundStyle(event.relativeTimeDate.daySymbolColor.mix(with: .primary, by: 0.1))
                                } else {
                                    if #available(iOS 16.0, *) {
                                        Image(systemName: event.relativeTimeDate.daySymbol)
                                            .foregroundStyle(event.relativeTimeDate.daySymbolColor.gradient)
                                    } else {
                                        Image(systemName: event.relativeTimeDate.daySymbol)
                                            .foregroundStyle(event.relativeTimeDate.daySymbolColor)
                                    }
                                }
                                Text(event.relativeTimeDate.timeString)
                            }
                            if event.relativeTimeDate.isOngoing {
                                HStack {
                                    Image(systemName: "record.circle")
                                        .font(.caption2)
                                        .apply {
                                            if #available(iOS 18.0, *) {
                                                $0.symbolEffect(.pulse .byLayer, options: .repeat(.continuous))
                                            } else {
                                                $0
                                            }
                                        }
                                    Text("Ongoing")
                                }
                                .foregroundStyle(.green)
                            } else {
                                HStack {
                                    Image(systemName: "clock")
                                        .symbolRenderingMode(.hierarchical)
                                        .opacity(0)
                                    Text(event.relativeTimeDate.timeLeftString)
                                        .foregroundStyle(event.relativeTimeDate.timeLeftString == "Soon" ? .orange : .secondary)
                                }
                            }
                        }
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundStyle(.secondary)
                        Text(event.relativeTimeDate.dateString)
                            .foregroundStyle(.secondary)
                    }
                    .font(.footnote)
                    .foregroundStyle(.primary)
                    
                }
                .padding(.leading, 10)
            }
        }
        .padding(15)
        .background {
            if #available(iOS 17.0, *) {
                if event.relativeTimeDate.isOngoing {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .fill(
                            .blueUTMbg.gradient.opacity(0.3)
                        )
                        .stroke(.tertiary, lineWidth: 2)
                } else if event.relativeTimeDate.isEventOver {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .fill(.white.opacity(0.05))
                        .stroke(.tertiary, lineWidth: 2)
                } else {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .fill(.white.opacity(0.05))
                        .stroke(.tertiary, lineWidth: 2)
                }
            } else {
                if event.relativeTimeDate.isOngoing {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .strokeBorder(.tertiary, lineWidth: 2)
                        .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.blueUTMbg.opacity(0.3)))
                } else if event.relativeTimeDate.isEventOver {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .strokeBorder(.tertiary, lineWidth: 2)
                        .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.white.opacity(0.05)))
                } else {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .strokeBorder(.tertiary, lineWidth: 2)
                        .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.white.opacity(0.05)))
                }
            }
        }
        .contentShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
    }
    
    func participationCheckNo() {
        categoryParser.unsaveEvent(event: event)
    }
    func participationCheckYes() {
        showingMedalAcceptance = true
    }
}

struct MedalAcceptanceSheet: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Binding var event: Event
    @Binding var showingMedalAcceptance: Bool
    @Binding var medal: Medal
    @Binding var didAccept: Bool
    
    @State var size: CGFloat = 100
    @State var rotation: Double = 0
    
    @State var confettiCount: Int = 0
    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Color.clear
                        Spacer()
                    }
                    Spacer()
                }
                    .onAppear {
                        self.size = min(abs(geo.size.width * 0.8), abs(geo.size.height * 0.4))
                    }
                    .onChange(of: geo.size) { _ in
                        self.size = min(abs(geo.size.width * 0.8), abs(geo.size.height * 0.4))
                    }
            }
            .overlay {
                VStack {
                    PickRotatingMedalType(size: $size, rotation: $rotation, medal: $medal)
                        .padding(.bottom, 15)
                        .id(confettiCount)
                    Text(CategoryToDisplayRepresentation(medal.category))
                        .font(.largeTitle .bold())
                    Text("Sessions: \(medal.events.count)")
                        .font(.title2 .bold())
                        .padding(.bottom, 25)
                        .apply {
                            if #available(iOS 16.0, *) {
                                $0.contentTransition(.numericText())
                            } else {
                                $0
                            }
                        }
                    Button(action: {
                        acceptMedal()
                    }) {
                        HStack {
                            Spacer()
                            Text(didAccept ? "Keep it up!" : "Accept Medal")
                            Spacer()
                        }
                        .font(.title3 .bold())
                        .foregroundStyle(.primary)
                        .padding(.vertical, 12)
                        .background {
                            if #available(iOS 17.0, *) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(didAccept ? .clear : .blueUTMbg)
                                    .stroke(.tertiary, lineWidth: 1)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(.tertiary, lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(didAccept ? .clear : .blueUTMbg))
                            }
                        }
                        .padding(20)
                    }
                    .buttonStyle(.plain)
                    .disabled(didAccept)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            }
        }
        .confettiCannon(counter: $confettiCount, num: 65, openingAngle: .degrees(330), closingAngle: .degrees(210), radius: 500)
    }
    func acceptMedal() {
        withAnimation {
            confettiCount += 1
            didAccept = true
            categoryParser.addMedal(event: event)
            categoryParser.updateMedalsCollected()
            event.saved = false
//            medal.type = .gold
//            medal.events.append(CompletedEvent(id: 666, sport: "Who Cares", category: medal.category, icon: medal.icon, date: Date()))
        }
    }
}

struct PickRotatingMedalType: View {
    @Binding var size: CGFloat
    @Binding var rotation: Double
    @Binding var medal: Medal
    var body: some View {
        if medal.type == .none {
            SportMedalEmpty(size: $size, medal: medal)
        } else {
            SportMedalRotation(size: $size, rotation: $rotation, symbol: ImageResource(name: medal.icon, bundle: .main), colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary)
        }
    }
}


@available(iOS 17.0, *)
#Preview {
    @Previewable @State var nm = NotificationManager()
    @Previewable @State var c = CategoryParser()
    return ContentView()
        .environmentObject(c)
        .environmentObject(nm)
}
