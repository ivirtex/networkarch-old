//
//  CellularData.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import Foundation
import CoreTelephony

let carrierInfo = CTCarrier()

struct CellularData {
    var carrierName = carrierInfo.carrierName
}
