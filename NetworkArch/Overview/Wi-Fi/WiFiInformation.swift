//
//  WiFiInformation.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

struct WiFiInfo {
    var networkName: String
    var macAddress: String
}

class WiFiInformation: NSObject {
    //  MARK - WiFi info
    func getWiFiInfo() -> WiFiInfo? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return nil
        }
        var wifiInfo: WiFiInfo? = nil
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else {
                return nil
            }
            guard let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            guard let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String else {
                return nil
            }
            
            wifiInfo = WiFiInfo(networkName: ssid, macAddress: bssid)
            break
        }
        return wifiInfo
    }
}
