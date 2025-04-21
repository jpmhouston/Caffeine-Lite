//
//  AppDelegate.swift
//  Caffeine
//
//  Created by Dominic Rodemer on 29.06.24.
//  Portions Copyright © 2025 Pierre Houston, Bananameter Labs. All rights reserved.
//

import Cocoa
import IOKit.pwr_mgt
import Sparkle

@main
class AppDelegate: NSObject, NSApplicationDelegate, SPUStandardUserDriverDelegate {
    
    var isActive:Bool
    var userSessionIsActive:Bool
    
    var timer:Timer!
    var timeoutTimer:Timer?
    var sleepAssertionID:IOPMAssertionID?
    
    @IBOutlet var menu:NSMenu!
    @IBOutlet var deactivateItem:NSMenuItem!

    var preferencesWindowController:PreferencesWindowController!
    var updaterController:SPUStandardUpdaterController!
    
    override init() {
        self.isActive = false
        self.userSessionIsActive = true
        
        super.init()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timer = Timer.scheduledTimer(timeInterval: 10.0,
                                     target: self,
                                     selector: #selector(AppDelegate.timer(_:)),
                                     userInfo: nil,
                                     repeats: true)
                
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(AppDelegate.workspaceSessionDidResignActiveNotification(_:)),
                                                          name: NSWorkspace.sessionDidResignActiveNotification,
                                                          object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(AppDelegate.workspaceSessionDidBecomeActiveNotification(_:)),
                                                          name: NSWorkspace.sessionDidBecomeActiveNotification,
                                                          object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(AppDelegate.workspaceWillSleepNotification(_:)),
                                                          name: NSWorkspace.willSleepNotification,
                                                          object: nil)
        
        UserDefaults.standard.register(defaults: ["CAActivateAtLaunch": false, "CADefaultDuration": 0, "CADeactivateOnManualSleep": false])
        
        preferencesWindowController = PreferencesWindowController(windowNibName: "PreferencesWindowController")
        updaterController = SPUStandardUpdaterController(startingUpdater: true,
                                                         updaterDelegate: nil,
                                                         userDriverDelegate: self);
        
        self.showPreferences(nil)
    }
    
    override func awakeFromNib() {
        if UserDefaults.standard.bool(forKey: "CAActivateAtLaunch") {
            self.activate()
        } else {
            self.updateUI()
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        // required when linking against macOS 14 SDK to silence a runtime warning
        return true
    }
    
    
    // MARK: Actions
    // MARK: ---
    @IBAction func timer(_ sender:Timer) {
        if isActive && userSessionIsActive {
            if self.sleepAssertionID != nil {
                IOPMAssertionRelease(self.sleepAssertionID!)
            }
            self.sleepAssertionID = IOPMAssertionID(0)
            print(kIOPMAssertPreventUserIdleDisplaySleep)
            IOPMAssertionCreateWithDescription(kIOPMAssertPreventUserIdleDisplaySleep as CFString,
                                               "Caffeine prevents sleep" as CFString,
                                               nil,
                                               nil,
                                               nil,
                                               8, //Timeout assertion after 8 sec
                                               nil,
                                               &self.sleepAssertionID!)
        }
    }
    
    @IBAction func timeoutReached(_ sender:Timer) {
        self.deactivate()
    }
    
    @IBAction func deactivate(_ sender:Any?) {
        self.deactivate()
    }
    
    @IBAction func activateWithTimeout(_ sender:NSMenuItem) {
        let minutes = sender.tag
        var seconds = minutes*60
        
        if seconds == -60 {
            seconds = 2
        }
        
        if minutes != 0 {
            self.activate(withTimeoutDuration: TimeInterval(seconds))
        } else {
            self.activate()
        }
    }
    
    @IBAction func showAbout(_ sender:Any?) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(sender)
        
        //let credits = "© 2006 Tomas Franzén\n© 2018 Michael Jones\n© 2022 Dominic Rodemer\n© 2025 Bananameter Labs \n\nSource code: https://github.com/jpmhouston/Caffeine-Lite"
        //NSApp.orderFrontStandardAboutPanel(options: [.credits : credits])
    }
    
    @IBAction func showPreferences(_ sender:Any?) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindowController.showWindow(self)
    }
    
    @IBAction func checkForUpdates(_ sender:Any?) {
        updaterController.checkForUpdates(sender)
    }
    
    
    // MARK:  Public
    // MARK:  ---
    func activate() {
        self.activate(withTimeoutDuration: 0.0)
    }
    
    func activate(withTimeoutDuration interval:TimeInterval) {
        if let timeoutTimer = self.timeoutTimer {
            timeoutTimer.invalidate()
        }
        
        if interval > 0 {
            timeoutTimer = Timer.scheduledTimer(timeInterval: interval,
                                                target: self,
                                                selector: #selector(AppDelegate.timeoutReached(_:)),
                                                userInfo: nil,
                                                repeats: false)
        }
        
        isActive = true
        
        self.updateUI()
    }
    
    func deactivate() {
        isActive = false
        
        if let timeoutTimer = self.timeoutTimer {
            timeoutTimer.invalidate()
        }
        timeoutTimer = nil
        
        self.updateUI()
    }
    
    func toggleActive(_ sender:Any?) {
        if let timeoutTimer = self.timeoutTimer {
            timeoutTimer.invalidate()
        }
        timeoutTimer = nil
        
        if isActive {
            self.deactivate()
        } else {
            let defaultMinutesDuration = UserDefaults.standard.integer(forKey: "CADefaultDuration")
            var seconds = defaultMinutesDuration*60
            
            if seconds == -60 {
                seconds = 2
            }
            
            if defaultMinutesDuration == 0 {
                self.activate(withTimeoutDuration: TimeInterval(seconds))
            } else {
                self.activate()
            }
        }
    }
    
    
    // MARK:  UI Synchronization
    // MARK:  ---
    func updateUI() {
        DispatchQueue.main.async { [weak self] in // since call from timer probably happens off the main thrad
            guard let self = self else { return }
            
            for item in self.menu.items {
                if item == self.deactivateItem {
                    item.isEnabled = self.isActive
                } else {
                    item.isEnabled = !self.isActive
                }
            }
            
            self.preferencesWindowController.showActivated(self.isActive)
        }
    }
    
    
    // MARK: SPUStandardUserDriverDelegate
    // MARK: ---
    func supportsGentleScheduledUpdateReminders() -> Bool {
        return true
    }
    
    
    // MARK: NSWorkspace Notifications
    // MARK: ---
    @objc func workspaceSessionDidResignActiveNotification(_ notification:NSNotification) {
        userSessionIsActive = false
    }
    
    @objc func workspaceSessionDidBecomeActiveNotification(_ notification:NSNotification) {
        userSessionIsActive = true
    }
    
    @objc func workspaceWillSleepNotification(_ notification:NSNotification) {
        if UserDefaults.standard.bool(forKey: "CADeactivateOnManualSleep") {
            self.deactivate()
        }
    }
}

