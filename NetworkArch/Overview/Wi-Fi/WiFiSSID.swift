//
//  WiFiSSID.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

func getWiFiSsid() -> String? {
    var ssid: String?
    if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                break
            }
        }
    }
    return ssid
}
