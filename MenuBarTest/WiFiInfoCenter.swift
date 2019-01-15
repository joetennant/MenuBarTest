//
//  WiFiInformationCenter.swift
//  MenuBarTest
//
//  Created by Joseph Tennant on 1/15/19.
//  Copyright © 2019 7SIGNAL. All rights reserved.
//

import Foundation
import CoreWLAN

struct WiFiInfo {
    var ssid: String?
    var bssid: String?
    var phyMode: String?
    var transmitRate = 0.0
    var channel = 0
    var channelWidth = 0
}

class WiFiInfoCenter {
    
    // get client instance
    static let client = CWWiFiClient.shared()
    
    static func getWifiConnectionInformation() -> WiFiInfo {
        
        // create a new result
        var infoResult = WiFiInfo()
        
        // get the detault interface
        if let interface = client.interface() {
            infoResult.ssid = interface.ssid()
            infoResult.bssid = interface.bssid()
            infoResult.phyMode = WiFiInfoCenter.getPhyModeString(interface: interface)
            infoResult.transmitRate = interface.transmitRate()
            if let channel = interface.wlanChannel() {
                infoResult.channel = channel.channelNumber
                infoResult.channelWidth = channel.channelWidth.rawValue
            }
        }
        
        return infoResult
    }
    
    static func getPhyModeString (interface : CWInterface) -> String {
        switch (interface.activePHYMode()) {
            case .mode11a:
                return "802.11a"
            case .mode11b:
                return "802.11b"
            case .mode11g:
                return "802.11g"
            case .mode11n:
                return "802.11n (HT)"
            case .mode11ac:
                return "802.11ac (VHT)"
            case .modeNone:
                return "Unknown"
        }
    }
    
    //MCS needs: YPHY, Streams, YDataRate, Yideally channel width
    
}


