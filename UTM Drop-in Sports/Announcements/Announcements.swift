//
//  Announcements.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-12-23.
//

import SwiftUI


struct Announcements: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var categoryParser: CategoryParser
    @State var isExpanded: Bool = false
    
    var body: some View {
        if !categoryParser.announcements.isEmpty {
            VStack(spacing: 0) {
                Button(action: {
                    for announcement in categoryParser.announcements {
                        announcement.markAsSeen()
                    }
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        if !categoryParser.announcements.allSatisfy({$0.seen}) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.red)
                                .font(.caption)
                        }
                        Text("Announcements")
                            .font(.headline)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .quaternary)
                            .font(.title3)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if isExpanded {
                    AnnouncementsList()
                }
            }
            .background {
                if colorScheme == .dark {
                    Rectangle()
                        .fill(.primary.opacity(0.085))
                } else {
                    Rectangle()
                        .fill(Color(red: 0.96, green: 0.96, blue: 0.975))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.top, 10)
            .padding(.bottom, 6)
            Divider()
                .padding(.bottom, 6)
        }
    }
}

struct AnnouncementsList: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            ForEach($categoryParser.announcements, id: \.id) { $announcement in
                AnnouncementView(announcement: $announcement)
            }
        }
        .padding(.vertical, 10)
        .background {
            if colorScheme == .dark {
                Rectangle()
                    .fill(.background.opacity(0.4))
            } else {
                Rectangle()
                    .fill(.background.opacity(0.5))
            }
        }
    }
}


struct AnnouncementView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var announcement: Announcement
    
    var body: some View {
        if let body = try? AttributedString(markdown: announcement.body, options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                .inlineOnlyPreservingWhitespace)) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .font(.headline)
                    Text(announcement.title.uppercased())
                    Spacer()
                }
                .foregroundStyle(.white, .quaternary)
                .font(.callout.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(.red.opacity(colorScheme == .dark ? 0.6 : 0.7))
                Text(body)
                    .font(.body)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 16)
            }
            .background {
                if colorScheme == .dark {
                    Rectangle()
                        .fill(.primary.opacity(0.085))
                } else {
                    Rectangle()
                        .fill(Color(red: 0.934, green: 0.934, blue: 0.945))
                }
            }
            .cornerRadius(16)
            .padding(.horizontal, 10)
        }
    }
}
