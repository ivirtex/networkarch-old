//
//  CellularData.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 01/08/2020.
//

import Foundation
import CoreTelephony

let carrierInfo = CTTelephonyNetworkInfo()

struct CellularData {
    let carrierDetail = carrierInfo.serviceSubscriberCellularProviders
    
//    let countryCode = carrierDetail.mobileCountryCode ?? "Not available"
//    let mobileNetworkName = carrierDetail.mobileNetworkCode ?? "Not available"
//    let isoCountrycode = carrierDetail.isoCountryCode?.uppercased() ?? "Not available"
}
