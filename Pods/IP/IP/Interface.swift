//
//  Interface.swift
//  IP
//
//  Created by Yu Sugawara on 2/3/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import Foundation
import libinfo

public struct Interface {
    public let name: String
    public let flags: Flags
    public let ip: IP
    public let netmask: IP
    
    public init(name: String, flags: Flags, ip: IP, netmask: IP) {
        self.name = name
        self.flags = flags
        self.ip = ip
        self.netmask = netmask
    }
    
    public init?(_ ifa: ifaddrs) {
        guard let cName = ifa.ifa_name,
            let name = String(validatingUTF8: cName) else { return nil }
        
        guard let ip = try? IP(ifa.ifa_addr) else { return nil }
        
        guard let netmask = try? IP(ifa.ifa_netmask) else { return nil }
        
        self.init(name: name,
                  flags: Flags(rawValue: ifa.ifa_flags),
                  ip: ip,
                  netmask: netmask)
    }
    
    public struct Flags: OptionSet {
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        public init(_ flag: Flag) {
            self.rawValue = flag.rawValue
        }
        
        public static let IFF_UP = Flags(.IFF_UP)
        public static let IFF_BROADCAST = Flags(.IFF_BROADCAST)
        public static let IFF_DEBUG = Flags(.IFF_DEBUG)
        public static let IFF_LOOPBACK = Flags(.IFF_LOOPBACK)
        public static let IFF_POINTOPOINT = Flags(.IFF_POINTOPOINT)
        public static let IFF_NOTRAILERS = Flags(.IFF_NOTRAILERS)
        public static let IFF_RUNNING = Flags(.IFF_RUNNING)
        public static let IFF_NOARP = Flags(.IFF_NOARP)
        public static let IFF_PROMISC = Flags(.IFF_PROMISC)
        public static let IFF_ALLMULTI = Flags(.IFF_ALLMULTI)
        public static let IFF_OACTIVE = Flags(.IFF_OACTIVE)
        public static let IFF_SIMPLEX = Flags(.IFF_SIMPLEX)
        public static let IFF_LINK0 = Flags(.IFF_LINK0)
        public static let IFF_LINK1 = Flags(.IFF_LINK1)
        public static let IFF_LINK2 = Flags(.IFF_LINK2)
        public static let IFF_ALTPHYS = Flags(.IFF_ALTPHYS)
        public static let IFF_MULTICAST = Flags(.IFF_MULTICAST)
        
        public enum Flag: UInt32 {
            case IFF_UP = 0x1 /* interface is up */
            case IFF_BROADCAST = 0x2 /* broadcast address valid */
            case IFF_DEBUG = 0x4 /* turn on debugging */
            case IFF_LOOPBACK = 0x8 /* is a loopback net */
            case IFF_POINTOPOINT	 = 0x10 /* interface is point-to-point link */
            case IFF_NOTRAILERS = 0x20 /* obsolete: avoid use of trailers */
            case IFF_RUNNING = 0x40 /* resources allocated */
            case IFF_NOARP = 0x80 /* no address resolution protocol */
            case IFF_PROMISC	 = 0x100 /* receive all packets */
            case IFF_ALLMULTI = 0x200 /* receive all multicast packets */
            case IFF_OACTIVE	 = 0x400 /* transmission in progress */
            case IFF_SIMPLEX	 = 0x800 /* can't hear own transmissions */
            case IFF_LINK0 = 0x1000 /* per link layer defined bit */
            case IFF_LINK1 = 0x2000 /* per link layer defined bit */
            case IFF_LINK2 = 0x4000 /* per link layer defined bit */
            public static let IFF_ALTPHYS = Flag.IFF_LINK2 /* use alternate physical connection */
            case IFF_MULTICAST = 0x8000 /* supports multicast */
        }
    }
}

extension Interface {
    
    /// Get network interfaces of the local system.
    /// [getifaddrs](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/getifaddrs.3.html)
    ///
    /// - Returns: all NIC
    /// - Throws: POSIX error
    public static func all() throws -> [Interface] {
        var interfacePtrs: UnsafeMutablePointer<ifaddrs>?        
        defer {
            if interfacePtrs != nil {
                freeifaddrs(interfacePtrs)
            }
        }
        
        if case let result = getifaddrs(&interfacePtrs), result != 0 {
            throw POSIXErrorCode(rawValue: result).map { IPError.posixError($0) } ?? IPError.unknown
        }
        
        guard let firstPtr = interfacePtrs else {
            throw IPError.unknown
        }
        
        return sequence(first: firstPtr.pointee,
                        next: { $0.ifa_next?.pointee })
            .compactMap({ Interface($0) })
    }
}

extension Interface: CustomStringConvertible {
    /// A human-readable description of the sort descriptor.
    public var description: String {
        return "Interface(" + "\n" +
            "\t" + "name: \(name)," + "\n" +
            "\t" + "flags: \(flags)" + "\n" +
            "\t" + "ip: \(ip)," + "\n" +
            "\t" + "netmask: \(netmask)," + "\n" +
        ")"
    }
}

extension Interface.Flags: CustomStringConvertible {
    /// A human-readable description of the sort descriptor.
    public var description: String {
        var i: UInt32 = 0
        return "[" +
            sequence(first: Flag(rawValue: 1 << i)!, next: { _ in
                i += 1;
                return Flag(rawValue: 1 << i)
            })
            .compactMap { contains(Interface.Flags($0)) ? $0 : nil }
            .compactMap { $0.description }
                .joined(separator: ", ")
            + "]"
    }
}

extension Interface.Flags.Flag: CustomStringConvertible {
    /// A human-readable description of the sort descriptor.
    public var description: String {
        switch self {
        case .IFF_UP: return "IFF_UP"
        case .IFF_BROADCAST: return "IFF_BROADCAST"
        case .IFF_DEBUG: return "IFF_DEBUG"
        case .IFF_LOOPBACK: return "IFF_LOOPBACK"
        case .IFF_POINTOPOINT	: return "IFF_POINTOPOINT"
        case .IFF_NOTRAILERS: return "IFF_NOTRAILERS"
        case .IFF_RUNNING: return "IFF_RUNNING"
        case .IFF_NOARP: return "IFF_NOARP"
        case .IFF_PROMISC	: return "IFF_PROMISC"
        case .IFF_ALLMULTI: return "IFF_ALLMULTI"
        case .IFF_OACTIVE	: return "IFF_OACTIVE"
        case .IFF_SIMPLEX	: return "IFF_SIMPLEX"
        case .IFF_LINK0: return "IFF_LINK0"
        case .IFF_LINK1: return "IFF_LINK1"
        case .IFF_LINK2: return "IFF_LINK2"
        case .IFF_MULTICAST: return "IFF_MULTICAST"
        }
    }
}
