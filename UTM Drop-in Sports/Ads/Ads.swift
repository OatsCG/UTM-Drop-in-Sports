//
//  Ads.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2025-01-07.
//

import Foundation
import SwiftUI
import GoogleMobileAds

class NativeAdViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
    let AD_UNIT_ID: String
    @Published var nativeAd: GADNativeAd?
    private var adLoader: GADAdLoader?
    
    init(_ id: String) {
        self.AD_UNIT_ID = id
    }

    func loadAd() {
        let adRequest = GADRequest()
        
        adLoader = GADAdLoader(
            adUnitID: AD_UNIT_ID,
            rootViewController: nil,
            adTypes: [.native],
            options: nil
        )
        adLoader?.delegate = self
        adLoader?.load(adRequest)
    }

    // MARK: - GADNativeAdLoaderDelegate

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        DispatchQueue.main.async {
            self.nativeAd = nativeAd
        }
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Failed to load native ad")
        print(error)
    }
}

struct AdaptiveBannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = findRootViewController()
        bannerView.delegate = context.coordinator
        loadAd(for: bannerView) // Load ad with adaptive size
        return bannerView
    }
    
    private func findRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return scene.windows.first { $0.isKeyWindow }?.rootViewController
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // No update needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Helper Functions

    private func loadAd(for bannerView: GADBannerView) {
        // Get the width of the screen for the current orientation
        let viewWidth = UIScreen.main.bounds.width

        // Calculate adaptive banner size
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        // Set the ad size and load an ad
        bannerView.adSize = adSize
        bannerView.load(GADRequest())
    }

    // MARK: - Coordinator for Ad Event Handling

    class Coordinator: NSObject, GADBannerViewDelegate {
        var parent: AdaptiveBannerAdView

        init(_ parent: AdaptiveBannerAdView) {
            self.parent = parent
        }

        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Adaptive banner ad loaded successfully.")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("Failed to load adaptive banner ad: \(error.localizedDescription)")
        }
    }
}


struct BannerAd: View {
    @StateObject var viewModel: NativeAdViewModel
    
    var body: some View {
        VStack {
            AdaptiveBannerAdView(adUnitID: viewModel.AD_UNIT_ID)
                .frame(height: 50)
        }
    }
}


struct SquareAd: View {
    @StateObject var viewModel: NativeAdViewModel
    
    var body: some View {
        VStack {
            AdaptiveBannerAdView(adUnitID: viewModel.AD_UNIT_ID)
                .frame(width: 300, height: 250)
        }
    }
}
