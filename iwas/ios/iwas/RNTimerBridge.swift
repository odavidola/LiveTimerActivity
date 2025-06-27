//  RNTimerBridge.swift
//  iwas
//
//  Exposes native timer controls to React Native.
//  NOTE: This is an extremely thin bridge – real logic lives in iwaTimerKit (TimerCoordinator).
//

import Foundation
import ActivityKit
import React
import iwaTimerKit

@objc(RNTimerBridge)
class RNTimerBridge: NSObject {
  private let coordinator = TimerCoordinator.shared
  
  @objc func startTimer(_ name: NSString, duration: NSNumber) {
    coordinator.start(name: name as String, duration: duration.intValue)
  }
  
  @objc func pauseTimer(_ name: NSString) {
    coordinator.pause(name: name as String)
  }
  
  @objc func resumeTimer(_ name: NSString) {
    coordinator.resume(name: name as String)
  }
  
  @objc func stopTimer(_ name: NSString) {
    coordinator.stop(name: name as String)
  }
  
  // MARK: - RCTBridgeModule
  @objc static func requiresMainQueueSetup() -> Bool {
    // UI updates happen via ActivityKit; safe to run off main thread.
    return false
  }
}
