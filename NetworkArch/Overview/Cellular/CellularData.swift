//
//  CellularData.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 01/08/2020.
//

import CoreTelephony
import Foundation

let carrierInfo = CTTelephonyNetworkInfo()

struct CellularData {
    let carrierDetail = carrierInfo.serviceSubscriberCellularProviders
    let carrierTechnology = carrierInfo.serviceCurrentRadioAccessTechnology
}
