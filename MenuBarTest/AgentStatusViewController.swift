//
//  AgentStatusViewController.swift
//  MenuBarTest
//
//  Created by Joseph Tennant on 1/11/19.
//  Copyright © 2019 7SIGNAL. All rights reserved.
//

import Cocoa

class AgentStatusViewController: NSViewController {
    
    var powerMonitor: PowerMonitor?
    var communicator: AgentCommunicator?
    
    @IBOutlet weak var lblSSID: NSTextField!
    @IBOutlet weak var lblBSSID: NSTextField!
    @IBOutlet weak var lblPhyMode: NSTextField!
    @IBOutlet weak var lblTxRate: NSTextField!
    @IBOutlet weak var lblChannel: NSTextField!
    @IBOutlet weak var lblChannelWidth: NSTextField!
    @IBOutlet weak var txtNotifications: NSTextField!
        
    @IBAction func btnRefreshClicked(sender: NSButton) {
        refreshWiFiInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToDaemon()
        refreshWiFiInfo()
        startPowerMonitor()
    }
    
    private func connectToDaemon() {
        communicator = AgentCommunicator()
        communicator!.setupNetworkCommunication()
        communicator!.sendMessage("Hello Daemon")
    }
    
    private func startPowerMonitor() {
        // Create PowerMonitor
        if powerMonitor == nil {
            powerMonitor = PowerMonitor()
            powerMonitor!.screensDidSleepHandler = { notification in
                self.txtNotifications.stringValue += "Screens went to sleep\n"
                self.communicator!.sendMessage("Screens went to sleep")
            }
            powerMonitor!.screensDidWakeHandler = { notification in
                self.txtNotifications.stringValue += "Screens are awake\n"
                self.communicator!.sendMessage("Screens are awake")
            }
            powerMonitor!.willSleepHandler = { notification in
                self.txtNotifications.stringValue += "Computer is sleeping\n"
                self.communicator!.sendMessage("Computer is sleeping")
            }
            powerMonitor!.didWakeHandler = { notification in
                self.txtNotifications.stringValue += "Computer is awake\n"
                self.communicator!.sendMessage("Computer is awake")
            }
        }
        powerMonitor?.start()
    }
    
    func refreshWiFiInfo() {
        let info = WiFiInfoCenter.getWifiConnectionInformation()
        lblSSID.stringValue = info.ssid!
        lblBSSID.stringValue = info.bssid!
        lblPhyMode.stringValue = info.phyMode!
        lblTxRate.stringValue = String(format: "%.2f", info.transmitRate)
        lblChannel.stringValue = String(format: "%i", info.channel)
        lblChannelWidth.stringValue = String(format: "%i", info.channelWidth)
        
        communicator!.sendMessage(info.ssid!)
    }
    
}

extension AgentStatusViewController {
    static func freshController() -> AgentStatusViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("AgentStatusViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? AgentStatusViewController else {
            fatalError("Why cant I find AgentStatusViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

