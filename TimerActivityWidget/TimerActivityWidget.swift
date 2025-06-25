//
//  TimerActivityWidget.swift
//  TimerActivityWidget
//
//  Created by Navin Kumar on 30/11/24.
//

import WidgetKit
import ActivityKit
import SwiftUI
import AppIntents

// MARK: - TimerActivityDynamicIsland Widget

struct TimerActivityDynamicIsland: Widget {
  
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: TimerActivityAttributes.self) { context in
      // Lock Screen view
      timerLockScreenView(context: context)
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded Dynamic Island Regions
        DynamicIslandExpandedRegion(.center) {
          timerDynamicIslandCenterView(context: context, foregroundColor: .white)
        }
        DynamicIslandExpandedRegion(.bottom) {
          timerDynamicIslandBottomView(context: context, foregroundColor: .white)
        }
      } compactLeading: {
        Image(systemName: context.state.isPaused ? "play.fill" : "pause.fill")
      } compactTrailing: {
        Image(systemName: "stop.fill")
      } minimal: {
        Image(systemName: "timer")
          .foregroundColor(.blue)
      }
    }
  }
  
  // MARK: - Center View for Dynamic Island and Lock Screen
  
  @ViewBuilder
  func timerDynamicIslandCenterView(
    context: ActivityViewContext<TimerActivityAttributes>,
    foregroundColor: Color) -> some View {
      VStack(spacing: 8) {
        Text(context.attributes.timerName)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(foregroundColor)
          .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
        
        HStack {
          Image(systemName: "backward")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(foregroundColor)
            .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
            .rotationEffect(.degrees(context.state.isPaused ? 180 : 0))
          
          if context.state.isPaused {
            Text(Utils.getExactTime(from: context.state.adjustedStartDate))
              .font(.system(size: 22, weight: .bold))
              .foregroundColor(foregroundColor)
              .monospacedDigit()
              .shadow(color: Color.black.opacity(0.5), radius: 1.5, x: 0, y: 1)
              .multilineTextAlignment(.center)
              .padding(.vertical, 4)
          } else {
            Text(context.state.adjustedStartDate, style: .relative)
              .font(.system(size: 22, weight: .bold))
              .foregroundColor(foregroundColor)
              .monospacedDigit()
              .shadow(color: Color.black.opacity(0.5), radius: 1.5, x: 0, y: 1)
              .multilineTextAlignment(.center)
              .padding(.vertical, 4)
          }
          
          Image(systemName: "forward")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(foregroundColor)
            .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
            .rotationEffect(.degrees(context.state.isPaused ? -180 : 0))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
      }
    }
  
  // MARK: - Bottom View for Dynamic Island and Lock Screen
  
  @ViewBuilder
  func timerDynamicIslandBottomView(
    context: ActivityViewContext<TimerActivityAttributes>,
    foregroundColor: Color) -> some View {
      HStack(spacing: 30) {
        // Play/Pause button
        Button(intent: PlayPauseTimerIntent(timerName: context.attributes.timerName)) {
          Image(systemName: context.state.isPaused ? "play.fill" : "pause.fill")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(foregroundColor)
            .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
            .frame(width: 44, height: 44)
            .background(
              Circle()
                .fill(Color.white.opacity(0.15))
            )
        }
        
        // Stop button
        Button(intent: StopTimerIntent(timerName: context.attributes.timerName)) {
          Image(systemName: "stop.fill")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(foregroundColor)
            .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
            .frame(width: 44, height: 44)
            .background(
              Circle()
                .fill(Color.white.opacity(0.15))
            )
        }
      }
      .padding(.horizontal)
    }
  
  // MARK: - Lock Screen View
  
  @ViewBuilder
  func timerLockScreenView(
    context: ActivityViewContext<TimerActivityAttributes>) -> some View {
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.white.opacity(0.8))
          .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        
        VStack(spacing: 12) {
          timerDynamicIslandCenterView(context: context, foregroundColor: .black)
          timerDynamicIslandBottomView(context: context, foregroundColor: .black)
        }
      }
      .frame(maxWidth: .infinity)
      .padding()
    }
}
