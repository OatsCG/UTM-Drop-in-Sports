//
//  _FlexView.swift
//  FlexView
//
//  Created by Brandon Erbschloe on 5/7/21.
//

import SwiftUI

struct _FlexView<Data: Collection & Equatable, Content: View>: View where Data.Element: Hashable {
    
    @Binding var availableWidth: CGFloat
    @Binding var data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    @State var elementsSize: [Data.Element: CGSize] = [:]
    @Binding var maxRows: Int
    
    @State var rows: [[Data.Element]] = []

    var body : some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(rows.prefix(maxRows), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                    }
                }
            }
        }
        .overlay {
            ZStack {
                ForEach(rows, id: \.self) { rowElements in
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                                computeRows(maxRows: self.maxRows, animate: false)
                            }
                    }
                }
            }
            .opacity(0)
            .disabled(true)
            .allowsHitTesting(false)
        }
        
        .onChange(of: availableWidth) { _, _ in
            computeRows(maxRows: self.maxRows, animate: false)
        }
        .onChange(of: maxRows) { _, _ in
            computeRows(maxRows: self.maxRows, animate: true)
        }
        .onChange(of: data) { _, _ in
            computeRows(maxRows: self.maxRows, animate: false)
        }
    }

    func computeRows(maxRows: Int, animate: Bool) {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth

        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 0)]

            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth
            }

            remainingWidth -= (elementSize.width + spacing)
        }
        if animate {
            withAnimation {
                self.rows = rows
            }
        } else {
            self.rows = rows
        }
    }
}
