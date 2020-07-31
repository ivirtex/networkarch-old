//
//  Error.swift
//  IP
//
//  Created by Yu Sugawara on 2/3/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import Foundation

public enum IPError: Error {
    case unknown
    case unsupportedAddressFamily(sa_family_t)
    case invalidAddress(String)
    case posixError(POSIXErrorCode)
}

extension IPError: LocalizedError {
    public var errorDescription: String? {
        return localizedDescription
    }
}

extension IPError {
    public var localizedDescription: String {
        switch self {
        case .unknown:
            return "Unknown Error."
        case .unsupportedAddressFamily(let family):
            return "Unsupported address family (\(family))."
        case .invalidAddress(let source):
            return "Invalid IP Address (\(source))."
        case .posixError(let code):
            return "POSIX Error, code: \(code.rawValue)"
        }
    }
}

