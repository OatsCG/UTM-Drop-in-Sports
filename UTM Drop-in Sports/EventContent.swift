//
//  EventContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventContent: View {
    @Binding var showingSheet: Bool
    var event: Event
    var body: some View {
        VStack {
            Button(action: {
                showingSheet = false
            }) {
                // down chevron sfsymbol
                Image(systemName: "chevron.compact.down")
                    .foregroundStyle(.tertiary)
                    .font(.title)
            }
            .buttonStyle(.plain)
            .padding()
            ScrollView {
                VStack {
                    HStack(alignment: .center) {
                        // soccerball of color #11264b
                        Image(systemName: "soccerball")
                            .font(.largeTitle)
                        Text("Drop-in Soccer")
                            .font(.title .bold())
                        Spacer()
                    }
                    .foregroundStyle(Color(red: 0.06666666666666667, green: 0.14901960784313725, blue: 0.29411764705882354))
                    //.foregroundStyle(Color(hue: 0.67, saturation: 0.05, brightness: 1.0))
                    
                    .padding(.bottom, 10)
                    VStack {
                        HStack {
                            HStack {
                                Image(systemName: "mappin")
                                    .symbolRenderingMode(.hierarchical)
                                Text("Gym A/B")
                            }
                            Spacer()
                        }
                        .font(.subheadline .bold())
                        .padding(.bottom, 2)
                        HStack {
                            Image(systemName: "clock")
                                .symbolRenderingMode(.hierarchical)
                            Text("9:00am - 10:00am")
                            Spacer()
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                            Text("Tuesday Sept 2")
                                .foregroundStyle(.secondary)
                        }
                        .font(.footnote)
                        .foregroundStyle(.primary)
                        
                    }
                    .padding(.leading, 10)
                    .padding(.bottom, 30)
                    
                    Text("Body description of event, which is super long and will wrap to multiple lines if needed (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it.")
                        .padding(.bottom, 30)
                    
                    HStack {
                        Button(action: {
                            
                        }) {
                            // UTM Event Website
                            Text("UTM Event Website")
                        }
                        Spacer()
                        Button(action: {
                            
                        }) {
                            // Event Admission status (none, book now, reserve your spot)
                            Text("Book now!")
                        }
                    }
                }
                .safeAreaPadding()
            }
        }
    }
}

#Preview {
    EventContent(showingSheet: .constant(true), event: Event())
}
