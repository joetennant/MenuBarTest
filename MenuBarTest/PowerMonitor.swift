//
//  PowerMonitor.swift
//  MenuBarTest
//
//  Created by Joseph Tennant on 1/15/19.
//  Copyright © 2019 7SIGNAL. All rights reserved.
//

import Foundation
import AppKit

public class PowerMonitor {
    private var wsCenter: NotificationCenter?
    
    public var screensDidSleepHandler: (Notification?) -> Void
    public var screensDidWakeHandler: (Notification?) -> Void
    
    public var willSleepHandler: (Notification?) -> Void
    public var didWakeHandler: (Notification?) -> Void
    
    init() {
        screensDidSleepHandler = {notification in }
        screensDidWakeHandler = {notification in }
        willSleepHandler = {notification in }
        didWakeHandler = {notification in }
    }
    
    public func start() {
        self.end() //ensure we don't restart
        wsCenter = NSWorkspace.shared.notificationCenter
        
        wsCenter?.addObserver(self,
                             selector: #selector(responsdToNotification(_:)),
                             name: NSWorkspace.screensDidSleepNotification,
                             object: nil)
        
        wsCenter?.addObserver(self,
                              selector: #selector(responsdToNotification(_:)),
                              name: NSWorkspace.screensDidWakeNotification,
                              object: nil)
        
        wsCenter?.addObserver(self,
                              selector: #selector(responsdToNotification(_:)),
                              name: NSWorkspace.willSleepNotification,
                              object: nil)
        
        wsCenter?.addObserver(self,
                              selector: #selector(responsdToNotification(_:)),
                              name: NSWorkspace.didWakeNotification,
                              object: nil)
    }
    
    public func end() {
        if wsCenter != nil {
            wsCenter!.removeObserver(self)
        }
    }
    
    @objc private func responsdToNotification(_ notification: Notification) {
        switch(notification.name) {
            case NSWorkspace.screensDidSleepNotification:
                screensDidSleepHandler(notification)
            case NSWorkspace.screensDidWakeNotification:
                screensDidWakeHandler(notification)
            case NSWorkspace.willSleepNotification:
                willSleepHandler(notification)
            case NSWorkspace.didWakeNotification:
                didWakeHandler(notification)
            default:
                print("Unhandled Notification: \(notification.name)")
        }
    }
}
