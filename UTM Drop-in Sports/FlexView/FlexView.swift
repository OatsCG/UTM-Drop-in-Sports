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
            Rectangle().foregroundColor(Color.clear).frame(height: 0).readSize { size in
                availableWidth = size.width
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
