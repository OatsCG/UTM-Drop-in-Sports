//
//  EventContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI
import GoogleMobileAds

struct EventContent: View {
    @Binding var showingSheet: Bool
    @Binding var event: Event
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    withAnimation {
                        showingSheet = false
                    }
                }) {
                    Image(systemName: "chevron.compact.down")
                        .foregroundStyle(.tertiary)
                        .font(.title)
                }
                .buttonStyle(.plain)
                .padding()
                
                ScrollView {
                    if #available(iOS 17.0, *) {
                        VStack {
                            EventImage(event: event)
                                .padding(.bottom, 18)
                            EventHeader(event: event)
                            Divider()
                                .padding(.vertical, 15)
                            EventBody(event: event)
                        }
                        .padding(.bottom, 65)
                        .safeAreaPadding()
                    } else {
                        VStack {
                            EventImage(event: event)
                                .padding(.bottom, 18)
                            VStack {
                                EventHeader(event: event)
                                Divider()
                                    .padding(.vertical, 15)
                                EventBody(event: event)
                            }
                                .padding(.horizontal)
                                .padding(.bottom, 65)
                        }
                    }
//                    SquareAd(viewModel: NativeAdViewModel(AD_UNIT_ID_BANNER_SQUARE))
//                        .padding(.bottom, 65)
                }
            }
            VStack {
                Spacer()
                BannerAd(viewModel: NativeAdViewModel(AD_UNIT_ID_BANNER))
            }
        }
    }
}
