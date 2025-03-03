//
//  PreferencesWindowController.swift
//  Caffeine
//
//  Created by Dominic Rodemer on 29.06.24.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    @IBOutlet var iconView:NSImageView!
    
    @IBOutlet var informationTextField:NSTextField!
    @IBOutlet var instructionsTextField:NSTextField!
    
    @IBOutlet var durationsTextField:NSTextField!
    @IBOutlet var durationButton:NSPopUpButton!
    
    @IBOutlet var activateAtLaunchButton:NSButton!
    @IBOutlet var deactivateOnManualSleepButton:NSButton!
    @IBOutlet var showAtLaunchButton:NSButton!
    
    @IBOutlet var quitButton:NSButton!
    @IBOutlet var closeButton:NSButton!
    
    override func loadWindow() {
        super.loadWindow()
        
        durationsTextField.sizeToFit()
        durationButton.sizeToFit()
        activateAtLaunchButton.sizeToFit()
        deactivateOnManualSleepButton.sizeToFit()
        showAtLaunchButton.sizeToFit()
        closeButton.sizeToFit()
        quitButton.sizeToFit()
        
        guard let window = self.window else {
            return
        }
        
        let toolbarHeight = window.frame.size.height - window.contentLayoutRect.size.height
        let edgeInsets = NSEdgeInsetsMake(20.0, 20.0, 13.0, 20.0)
        
        let textX = edgeInsets.left + iconView.frame.size.width + edgeInsets.right;
        let textWidth = max(activateAtLaunchButton.frame.size.width,
                            deactivateOnManualSleepButton.frame.size.width,
                            showAtLaunchButton.frame.size.width)

        var windowHeight = 0.0
        let windowWidth = textX + textWidth + edgeInsets.left
            
        windowHeight += edgeInsets.bottom
        quitButton.frame = NSMakeRect(13.0,
                                      windowHeight,
                                      quitButton.frame.size.width,
                                      quitButton.frame.size.height)
        closeButton.frame = NSMakeRect(windowWidth - 13.0 - closeButton.frame.size.width,
                                       windowHeight,
                                       closeButton.frame.size.width,
                                       closeButton.frame.size.height)
        windowHeight += quitButton.frame.size.height
        
        
        windowHeight += edgeInsets.bottom;
        showAtLaunchButton.frame = NSMakeRect(textX,
                                              windowHeight,
                                              showAtLaunchButton.frame.size.width,
                                              showAtLaunchButton.frame.size.height);
        windowHeight += showAtLaunchButton.frame.size.height + 4.0
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
        
        windowHeight += 3*edgeInsets.bottom
        let instructionsTextFieldSize = instructionsTextField.sizeThatFits(NSMakeSize(textWidth, CGFLOAT_MAX));
        instructionsTextField.frame = NSMakeRect(textX,
                                                 windowHeight,
                                                 textWidth,
                                                 instructionsTextFieldSize.height)
        windowHeight += instructionsTextField.frame.size.height + edgeInsets.bottom
        let informationTextFieldSize = informationTextField.sizeThatFits(NSMakeSize(textWidth, CGFLOAT_MAX));
        informationTextField.frame = NSMakeRect(textX,
                                                windowHeight,
                                                textWidth,
                                                informationTextFieldSize.height);
        windowHeight += informationTextField.frame.size.height
        
        iconView.frame = NSMakeRect(edgeInsets.left,
                                    windowHeight - iconView.frame.size.height,
                                    iconView.frame.size.height,
                                    iconView.frame.size.width)
        
        windowHeight += edgeInsets.top + toolbarHeight
        window.setFrame(NSMakeRect(0.0, 0.0, windowWidth, windowHeight), display: false)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        showAtLaunchButton.state = UserDefaults.standard.bool(forKey: "CASuppressLaunchMessage") ? .off : .on
        activateAtLaunchButton.state = UserDefaults.standard.bool(forKey: "CAActivateAtLaunch") ? .on : .off
        deactivateOnManualSleepButton.state = UserDefaults.standard.bool(forKey: "CADeactivateOnManualSleep") ? .on : .off
        durationButton.selectItem(withTag: UserDefaults.standard.integer(forKey: "CADefaultDuration"))
    }
    
    override func showWindow(_ sender: Any?) {
        self.window?.center()
        super.showWindow(sender)
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
    
    @IBAction func showAtLaunchButtonAction(_ sender:Any?) {
        let supressAtLaunch = (showAtLaunchButton.state == .off) ? true : false
        UserDefaults.standard.setValue(supressAtLaunch, forKey: "CASuppressLaunchMessage")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func closeButtonAction(_ sender:Any?) {
        self.close()
    }
    
    @IBAction func quitButtonAction(_ sender:Any?) {
        NSApp.terminate(self)
    }
}
