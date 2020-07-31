//
//  CellularData.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import Foundation
import CoreTelephony

let carrier = CTCarrier()

struct CellularData {
    var carrierName = carrier.carrierName
    var voIPBool = carrier.allowsVOIP
    var isoCountryCode = carrier.isoCountryCode
    var mobileCountryCode = carrier.mobileCountryCode
    var mobileNetworkCode = carrier.mobileNetworkCode
}
