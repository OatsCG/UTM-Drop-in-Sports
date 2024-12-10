//
//  FlexView.swift
//  FlexView
//
//  Created by Brandon Erbschloe on 5/7/21.
//

import SwiftUI

public struct FlexView<Data: Collection & Equatable, Content: View>: View where Data.Element: Hashable {
    
    @Binding var data: Data
    var spacing: CGFloat = 8
    var alignment: HorizontalAlignment = .leading
    @Binding var maxRows: Int
    var content: (Data.Element) -> Content
    
    @State private var availableWidth: CGFloat = 0

    public var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            GeometryReader { geo in
                Rectangle().foregroundColor(.clear).frame(height: 0)
                    .onChange(of: geo.size.width) { width in
                        availableWidth = width
                    }
                    .onAppear {
                        availableWidth = geo.size.width
                    }
                    .frame(width: geo.size.width)
            }
            _FlexView(
                availableWidth: $availableWidth,
                data: $data,
                spacing: spacing,
                alignment: alignment,
                content: content,
                maxRows: $maxRows
            )
        }
    }
}
