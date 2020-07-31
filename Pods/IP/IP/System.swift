//
//  System.swift
//  IP
//
//  Created by Yu Sugawara on 2/6/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import Foundation
#if !((arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))) || swift(>=3.2)
    import libnetwork
#endif

public struct System {
    
    /// Management Information Base (MIB)
    public enum MIB {
        case routingTable
        case defaultGateway(IP.Version)
        
        public var rawValue: [Int32] {
            switch self {
            case .routingTable:
                return [CTL_NET,
                        PF_ROUTE,
                        0,
                        0,
                        NET_RT_DUMP2,
                        0]
            case .defaultGateway(let version):
                return [CTL_NET,
                        PF_ROUTE,
                        0,
                        version.type,
                        NET_RT_FLAGS,
                        RTF_GATEWAY]
            }
        }
    }
    
    /// [route.c](https://opensource.apple.com/source/network_cmds/network_cmds-325/netstat.tproj/route.c)
    public static func routingTable(_ includeFlags: RoutingMessage.Flags = []) throws -> [RoutingMessage]? {
        let buffer = try sysctl(.routingTable)
        
        return buffer.withUnsafeBufferPointer { dataPointer -> [RoutingMessage]? in
            guard let first = (dataPointer.baseAddress.map { $0.withMemoryRebound(to: Int8.self,
                                                                                  capacity: 1,
                                                                                  { $0 }) }) else
            {
                return nil
            }
            var next = first
            
            var messages = [RoutingMessage]()
            
            while dataPointer.count > first.distance(to: next) {
                let msgPtr = next.withMemoryRebound(to: rt_msghdr2.self,
                                                    capacity: 1,
                                                    { $0 })
                
                if let msg = RoutingMessage(msgPtr),
                    msg.flags.contains(includeFlags)
                {
                    messages.append(msg)
                }
                
                next = next.advanced(by: Int(msgPtr.pointee.rtm_msglen)/MemoryLayout<Int8>.stride)
            }
            
            return messages
        }
    }
    
    // MARK: -
    
    public static func retrieveDefaultGatewayMessage(from interface: Interface) throws -> RoutingMessage? {
        return try retrieveDefaultGatewayMessage(name: interface.name,
                                                 version: interface.ip.version)
    }
    
    public static func retrieveDefaultGatewayMessage(from ip: IP) throws -> RoutingMessage? {
        guard let name = try Interface.all()
            .first(where: { $0.ip == ip })
            .map({ $0.name }) else
        {
            return nil
        }
        return try retrieveDefaultGatewayMessage(name: name,
                                                 version: ip.version)
    }
    
    public static func retrieveDefaultGatewayMessage(name: String, version: IP.Version) throws -> RoutingMessage? {
        return try retrieveDefaultGatewayMessage(version: version,
                                                 flags: .availableNetwork,
                                                 where: {
                                                    $0.name == name
                                                        && $0.destination.version == version
                                                        && $0.gateway.map { $0.version == version } ?? false
        })
    }
    
    public static func retrieveDefaultGatewayMessage(version: IP.Version, flags: RoutingMessage.Flags = [], where: ((RoutingMessage) -> Bool)) throws -> RoutingMessage? {
        let buffer = try sysctl(.defaultGateway(version))
        
        return buffer.withUnsafeBufferPointer { dataPointer -> RoutingMessage? in
            guard let first = (dataPointer.baseAddress.map { $0.withMemoryRebound(to: Int8.self,
                                                                                  capacity: 1,
                                                                                  { $0 }) }) else
            {
                return nil
            }
            var next = first
            
            while dataPointer.count > first.distance(to: next) {
                let messagePtr = next.withMemoryRebound(to: rt_msghdr.self,
                                                        capacity: 1,
                                                        { $0 })
                if let message = RoutingMessage(messagePtr),
                    message.flags.contains(flags),
                    `where`(message)
                {
                    return message
                }
                
                next = next.advanced(by: Int(messagePtr.pointee.rtm_msglen)/MemoryLayout<Int8>.stride)
            }
            
            return nil
        }
    }
    
    // MARK: -
    
    /// [sysctl](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/sysctl.3.html)
    ///
    /// - Parameter mib: <#mib description#>
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public static func sysctl(_ mib: MIB) throws -> [Int8] {
        return try sysctl(mib.rawValue)
    }
    
    public static func sysctl(_ mib: [Int32]) throws -> [Int8] {
        return try mib.withUnsafeBufferPointer() { mibPtr throws -> [Int8] in
            var bufferSize = 0
            do {
                let errno = Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: mibPtr.baseAddress),
                                          UInt32(mib.count),
                                          nil,
                                          &bufferSize,
                                          nil,
                                          0)
                if errno != 0 {
                    throw POSIXErrorCode(rawValue: errno).map { IPError.posixError($0) } ?? IPError.unknown
                }
            }
            
            let buffer = Array<Int8>(repeating: 0, count: bufferSize)
            do {
                let errno = buffer.withUnsafeBufferPointer() { buffer -> Int32 in
                    return Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: mibPtr.baseAddress),
                                         UInt32(mib.count),
                                         UnsafeMutableRawPointer(mutating: buffer.baseAddress),
                                         &bufferSize,
                                         nil,
                                         0)
                }
                if errno != 0 {
                    throw POSIXErrorCode(rawValue: errno).map { IPError.posixError($0) } ?? IPError.unknown
                }
            }
            
            return buffer
        }
    }
    
}
