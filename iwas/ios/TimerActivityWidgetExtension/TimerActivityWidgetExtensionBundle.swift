//
//  TimerActivityWidgetExtensionBundle.swift
//  TimerActivityWidgetExtension
//
//  Created by David Olagunju on 27/06/2025.
//

import WidgetKit
import SwiftUI

@main
struct TimerActivityWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        TimerActivityWidgetExtension()
        TimerActivityWidgetExtensionControl()
        TimerActivityWidgetExtensionLiveActivity()
    }
}
