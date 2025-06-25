//
//  TimerView.swift
//  LiveTimerActivity
//
//  Created by Navin Kumar on 01/12/24.
//

import SwiftUI

struct TimerView: View {
  @Environment(\.scenePhase) var scenePhase
  @StateObject private var viewModel: TimerViewModel
      
  init(timerType: TimerType) {
    _viewModel = StateObject(wrappedValue: TimerViewModel(timerName: timerType.rawValue))
  }
  
  var body: some View {
    mainView
      .onChange(of: scenePhase) { oldPhase, newPhase in
        if newPhase == .active {
          Task {
            viewModel.loadExistingTimer()
          }
        }
      }
  }
  
  private var mainView: some View {
    ZStack {
      Color(UIColor.systemGroupedBackground)
        .ignoresSafeArea()
      
      VStack(spacing: 25) {
        titleView
        timerStatusView
          .padding(.horizontal)
        controlButtonsView
      }
      .padding()
    }
  }
  
  private func startTimer() {
    viewModel.startTimerActivity()
  }
  
  private func stopTimer() {
    Task {
      await viewModel.stopTimerActivity()
    }
  }
  
  private var titleView: some View {
    Text(viewModel.timerName)
      .font(.system(size: 28, weight: .bold))
      .foregroundColor(.primary)
      .padding(.vertical, 5)
      .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
  }
  
  private var timerStatusView: some View {
    Group {
      if !viewModel.isTimerRunning {
        // Show elapsed time from adjustedStartDate (not running)
        Text(Utils.getExactTime(from: viewModel.adjustedStartDate))
          .font(.system(size: 42, weight: .semibold))
          .foregroundColor(.blue)
          .monospacedDigit()
          .padding(.vertical, 10)
          .frame(minHeight: 60)
          .shadow(color: .blue.opacity(0.3), radius: 3, x: 0, y: 2)
      } else if viewModel.isPaused {
        // Show elapsed time from adjustedStartDate to pauseDate
        if let pauseDate = viewModel.pauseDate {
          Text(Utils.getExactTime(from: viewModel.adjustedStartDate, to: pauseDate))
            .font(.system(size: 42, weight: .semibold))
            .foregroundColor(.orange)
            .monospacedDigit()
            .padding(.vertical, 10)
            .frame(minHeight: 60)
            .shadow(color: .orange.opacity(0.3), radius: 3, x: 0, y: 2)
        } else {
          Text(Utils.getExactTime(from: viewModel.adjustedStartDate))
            .font(.system(size: 42, weight: .semibold))
            .foregroundColor(.orange)
            .monospacedDigit()
            .padding(.vertical, 10)
            .frame(minHeight: 60)
            .shadow(color: .orange.opacity(0.3), radius: 3, x: 0, y: 2)
        }
      } else {
        // Show live updating relative time
        Text(viewModel.adjustedStartDate, style: .relative)
            .font(.system(size: 42, weight: .semibold))
            .foregroundColor(.green)
            .monospacedDigit()
            .padding(.vertical, 10)
            .frame(minHeight: 60)
            .shadow(color: .green.opacity(0.3), radius: 3, x: 0, y: 2)
      }
    }
    .padding(.horizontal)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(UIColor.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    )
  }
  
  private var controlButtonsView: some View {
    HStack(spacing: 20) {
      startPauseButton
      stopButton
    }
    .padding(.horizontal)
  }
  
  private var startPauseButton: some View {
    Group {
      if !viewModel.isTimerRunning {
        actionButton(title: "Start Timer", color: .green, action: startTimer)
      } else if viewModel.isPaused {
        actionButton(title: "Resume Timer", color: .blue) {
          viewModel.togglePause()
        }
      } else {
        actionButton(title: "Pause Timer", color: .yellow) {
          viewModel.togglePause()
        }
      }
    }
  }
  
  private var stopButton: some View {
    actionButton(title: "Stop Timer", color: .red, action: stopTimer)
      .disabled(!viewModel.isTimerRunning)
  }
  
  private func actionButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: 18, weight: .bold))
        .padding()
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [color, color.opacity(0.8)]),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
    }
  }
}
