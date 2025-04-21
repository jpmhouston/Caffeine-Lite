//
//  PreferencesWindowController.swift
//  Caffeine
//
//  Created by Dominic Rodemer on 29.06.24.
//  Portions Copyright © 2025 Pierre Houston, Bananameter Labs. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    @IBOutlet var iconView:NSImageView!
    
    @IBOutlet var inactiveInformationTextField:NSTextField!
    @IBOutlet var activeInformationTextField:NSTextField!
    
    @IBOutlet var durationsTextField:NSTextField!
    @IBOutlet var durationButton:NSPopUpButton!
    
    @IBOutlet var activateAtLaunchButton:NSButton!
    @IBOutlet var deactivateOnManualSleepButton:NSButton!
    
    @IBOutlet var activateButton:NSButton!
    @IBOutlet var deactivateButton:NSButton!
    
    override func loadWindow() {
        super.loadWindow()
        
        durationsTextField.sizeToFit()
        durationButton.sizeToFit()
        activateAtLaunchButton.sizeToFit()
        deactivateOnManualSleepButton.sizeToFit()
        activateButton.sizeToFit()
        deactivateButton.sizeToFit()
        
        guard let window = self.window else {
            return
        }
        
        let toolbarHeight = window.frame.size.height - window.contentLayoutRect.size.height
        let edgeInsets = NSEdgeInsetsMake(20.0, 20.0, 13.0, 20.0)
        
        let textX = edgeInsets.left + iconView.frame.size.width + edgeInsets.right;
        let textWidth = max(activateAtLaunchButton.frame.size.width,
                            deactivateOnManualSleepButton.frame.size.width)
        
        var windowHeight = 0.0
        let windowWidth = textX + textWidth + edgeInsets.left
        
        
        windowHeight += 1.5 * edgeInsets.bottom
        let toggleButtonsWidth = max(activateButton.frame.size.width,
                                     deactivateButton.frame.size.width)
        activateButton.frame = NSMakeRect(textX,
                                          windowHeight,
                                          toggleButtonsWidth,
                                          activateButton.frame.size.height)
        deactivateButton.frame = NSMakeRect(textX,
                                            windowHeight,
                                            toggleButtonsWidth,
                                            deactivateButton.frame.size.height)
        windowHeight += deactivateButton.frame.size.height
        
        
        windowHeight += 2 * edgeInsets.bottom;
        deactivateOnManualSleepButton.frame = NSMakeRect(textX,
                                                         windowHeight,
                                                         deactivateOnManualSleepButton.frame.size.width,
                                                         deactivateOnManualSleepButton.frame.size.height)
        windowHeight += deactivateOnManualSleepButton.frame.size.height + 4.0
        activateAtLaunchButton.frame = NSMakeRect(textX,
                                                  windowHeight,
                                                  activateAtLaunchButton.frame.size.width,
                                                  activateAtLaunchButton.frame.size.height)
        windowHeight += activateAtLaunchButton.frame.size.height + 4.0
        durationsTextField.frame = NSMakeRect(textX,
                                              windowHeight,
                                              durationsTextField.frame.size.width,
                                              durationButton.frame.size.height)
        durationButton.frame = NSMakeRect(textX + durationsTextField.frame.size.width + 4.0,
                                          windowHeight,
                                          durationButton.frame.size.width,
                                          durationButton.frame.size.height)
        windowHeight += durationButton.frame.size.height
        
        
        windowHeight += 2 * edgeInsets.bottom
        let activeTextFieldSize = activeInformationTextField.sizeThatFits(NSMakeSize(textWidth, CGFLOAT_MAX));
        let inactiveTextFieldSize = inactiveInformationTextField.sizeThatFits(NSMakeSize(textWidth, CGFLOAT_MAX));
        let textFieldSize = NSMakeSize(max(activeTextFieldSize.width, inactiveTextFieldSize.width),
                                       max(activeTextFieldSize.height, inactiveTextFieldSize.height))
        
        activeInformationTextField.frame = NSMakeRect(textX,
                                                      windowHeight,
                                                      textFieldSize.width,
                                                      textFieldSize.height)
        inactiveInformationTextField.frame = activeInformationTextField.frame
        windowHeight += textFieldSize.height
        
        
        iconView.frame = NSMakeRect(edgeInsets.left,
                                    windowHeight - iconView.frame.size.height,
                                    iconView.frame.size.height,
                                    iconView.frame.size.width)
        
        windowHeight += edgeInsets.top + toolbarHeight
        window.setFrame(NSMakeRect(0.0, 0.0, windowWidth, windowHeight), display: false)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        activateAtLaunchButton.state = UserDefaults.standard.bool(forKey: "CAActivateAtLaunch") ? .on : .off
        deactivateOnManualSleepButton.state = UserDefaults.standard.bool(forKey: "CADeactivateOnManualSleep") ? .on : .off
        durationButton.selectItem(withTag: UserDefaults.standard.integer(forKey: "CADefaultDuration"))
    }
    
    override func showWindow(_ sender: Any?) {
        self.window?.center()
        super.showWindow(sender)
    }
    
    func showActivated(_ isActivated: Bool) {
        inactiveInformationTextField.isHidden = isActivated
        activeInformationTextField.isHidden = !isActivated
        
        activateButton.isHidden = isActivated
        deactivateButton.isHidden = !isActivated
    }
    
    @IBAction func durationButtonAction(_ sender:Any?) {
        var duration = 0
        if let selectedItem = durationButton.selectedItem {
            duration = selectedItem.tag
        }
        UserDefaults.standard.setValue(duration, forKey: "CADefaultDuration")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func activateAtLaunchButtonAction(_ sender:Any?) {
        let activateAtLaunch = (activateAtLaunchButton.state == .on) ? true : false
        UserDefaults.standard.setValue(activateAtLaunch, forKey: "CAActivateAtLaunch")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func deactivateOnManualSleepButtonAction(_ sender:Any?) {
        let deactivateOnManualSleep = (deactivateOnManualSleepButton.state == .on) ? true : false;
        UserDefaults.standard.setValue(deactivateOnManualSleep, forKey: "CADeactivateOnManualSleep")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func activateButtonAction(_ sender:Any?) {
        (NSApp.delegate as? AppDelegate)?.activate()
    }
    
    @IBAction func deactivateButtonAction(_ sender:Any?) {
        (NSApp.delegate as? AppDelegate)?.deactivate()
    }
}
