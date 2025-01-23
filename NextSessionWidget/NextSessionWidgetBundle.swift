//
//  NextSessionWidgetBundle.swift
//  NextSessionWidget
//
//  Created by Charlie Giannis on 2025-01-22.
//

import WidgetKit
import SwiftUI

@main
struct NextSessionWidgetBundle: WidgetBundle {
    var body: some Widget {
        NextSessionWidget()
        NextSessionWidgetControl()
        NextSessionWidgetLiveActivity()
    }
}
