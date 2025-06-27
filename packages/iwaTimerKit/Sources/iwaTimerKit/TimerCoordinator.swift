//  TimerCoordinator.swift
//  iwaTimerKit
//
//  Handles starting/pausing/stopping timers via ActivityKit.
//  For now, this is a very small scaffold so the RN bridge compiles.
//  You can flesh out real timing + storage logic later.

import Foundation
import ActivityKit

public final class TimerCoordinator {
  public static let shared = TimerCoordinator()
  private init() {}
  
  // For demo purposes we keep activities in memory
  private var activities: [String: Activity<TimerActivityAttributes>] = [:]
  private let store = UserDefaults(suiteName: "group.com.davidola.iwa")!
  
  public func start(name: String, duration: Int) {
    store.set(["state": "running", "start": Date().timeIntervalSince1970, "duration": duration], forKey: name)
    let attr = TimerActivityAttributes(timerName: name)
    let state = TimerActivityAttributes.ContentState(isPaused: false, pauseDate: nil, adjustedStartDate: Date())
    if let activity = try? Activity.request(attributes: attr, contentState: state, pushType: nil) {
      activities[name] = activity
    }
  }
  
  public func pause(name: String) {
    store.setValue(["state": "paused", "pause": Date().timeIntervalSince1970], forKey: name)
    guard let activity = activities[name] else { return }
    let state = TimerActivityAttributes.ContentState(isPaused: true, pauseDate: Date(), adjustedStartDate: activity.contentState.adjustedStartDate)
    Task { await activity.update(using: state) }
  }
  
  public func resume(name: String) {
    store.setValue(["state": "running", "resume": Date().timeIntervalSince1970], forKey: name)
    guard let activity = activities[name] else { return }
    let state = TimerActivityAttributes.ContentState(isPaused: false, pauseDate: nil, adjustedStartDate: Date())
    Task { await activity.update(using: state) }
  }
  
  public func stop(name: String) {
    store.removeObject(forKey: name)
    guard let activity = activities[name] else { return }
    Task { await activity.end(dismissalPolicy: .immediate) }
    activities.removeValue(forKey: name)
  }
}
