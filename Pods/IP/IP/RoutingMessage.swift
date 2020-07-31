//
//  RoutingMessage.swift
//  IP
//
//  Created by Yu Sugawara on 2/4/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import Foundation
#if !((arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))) || swift(>=3.2)
    import libnetwork
#endif

public protocol RoutingMessageInitializable  {
    var rtm_index: u_short { get }
    var rtm_flags: Int32 { get }
    var rtm_addrs: Int32 { get }
}

extension rt_msghdr: RoutingMessageInitializable {
}

extension rt_msghdr2: RoutingMessageInitializable {
}

public struct RoutingMessage {
    public var name: String
    public let flags: Flags
    
    /* Unsupported AF_LINK */
    
    public let destination: IP
    public let gateway: IP?
    public let netmask: IP?
    public let cloning: IP?
    public let interfaceName: IP?
    public let interface: IP?
    public let authorOfRedirect: IP?
    public let broadcast: IP?
    
    public init?<T: RoutingMessageInitializable>(_ messagePtr: UnsafePointer<T>) {
        let message = messagePtr.pointee
        
        guard let name: String = {
            var cName = Array<Int8>(repeating: 0, count: Int(IF_NAMESIZE))
            if if_indextoname(UInt32(message.rtm_index), &cName) == nil { return nil }
            return String(validatingUTF8: cName)
            }() else { return nil }
        
        self.name = name
        self.flags = RoutingMessage.Flags(rawValue: message.rtm_flags)
        
        guard let destination: IP = {
            let destPtr = messagePtr.advanced(by: 1).withMemoryRebound(to: sockaddr.self,
                                                                       capacity: 1,
                                                                       { $0 })
            return try? IP(UnsafeMutablePointer(mutating: destPtr))
            }() else { return nil }
        self.destination = destination
        
        var gateway: IP?; var netmask: IP?; var cloning: IP?; var interfaceName: IP?; var interface: IP?; var authorOfRedirect: IP?; var broadcast: IP?
        var socketPtr = messagePtr.advanced(by: 1).withMemoryRebound(to: Int8.self,
                                                                     capacity: 1,
                                                                     { $0 })
        
        for offset in 0..<RTAX_MAX {
            if message.rtm_addrs & (1 << offset) == 0 { continue }
            
            let ipPtr = socketPtr.withMemoryRebound(to: sockaddr.self,
                                                    capacity: 1,
                                                    { $0 })
            
            if let ip = try? IP(UnsafeMutablePointer(mutating: ipPtr)) {
                switch offset {
                case RTAX_DST: /* destination sockaddr present */
                    break
                case RTAX_GATEWAY: /* gateway sockaddr present */
                    gateway = ip
                case RTAX_NETMASK: /* netmask sockaddr present */
                    netmask = ip
                case RTAX_GENMASK: /* cloning mask sockaddr present */
                    cloning = ip
                case RTAX_IFP: /* interface name sockaddr present */
                    interfaceName = ip
                case RTAX_IFA: /* interface addr sockaddr present */
                    interface = ip
                case RTAX_AUTHOR: /* sockaddr for author of redirect */
                    authorOfRedirect = ip
                case RTAX_BRD: /* for NEWADDR, broadcast or p-p dest addr */
                    broadcast = ip
                case RTAX_MAX: /* size of array to allocate */
                    break
                default:
                    break
                }
            }
            socketPtr = socketPtr.advanced(by: { () -> Int in
                let sock = socketPtr.withMemoryRebound(to: sockaddr.self,
                                                       capacity: 1,
                                                       { $0 }).pointee
                
                let len = sock.sa_len
                if len > 0 {
                    return (1 + ((Int((len) - 1)) | (MemoryLayout<CLong>.size - 1)))
                }
                return MemoryLayout<CLong>.size
            }())
        }
        
        self.gateway = gateway
        self.netmask = netmask
        self.cloning = cloning
        self.interfaceName = interfaceName
        self.interface = interface
        self.authorOfRedirect = authorOfRedirect
        self.broadcast = broadcast
    }
    
    public struct Flags: OptionSet {
        public let rawValue: Int32
        
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        public init(_ flag: Flag) {
            self.rawValue = flag.rawValue
        }
        
        public static let RTF_UP = Flags(.RTF_UP)
        public static let RTF_GATEWAY = Flags(.RTF_GATEWAY)
        public static let RTF_HOST = Flags(.RTF_HOST)
        public static let RTF_REJECT = Flags(.RTF_REJECT)
        public static let RTF_DYNAMIC = Flags(.RTF_DYNAMIC)
        public static let RTF_MODIFIED = Flags(.RTF_DYNAMIC)
        public static let RTF_DONE = Flags(.RTF_DONE)
        public static let RTF_DELCLONE = Flags(.RTF_DELCLONE)
        public static let RTF_CLONING = Flags(.RTF_CLONING)
        public static let RTF_XRESOLVE = Flags(.RTF_XRESOLVE)
        public static let RTF_LLINFO = Flags(.RTF_LLINFO)
        public static let RTF_STATIC = Flags(.RTF_STATIC)
        public static let RTF_BLACKHOLE = Flags(.RTF_BLACKHOLE)
        public static let RTF_NOIFREF = Flags(.RTF_NOIFREF)
        public static let RTF_PROTO2 = Flags(.RTF_PROTO2)
        public static let RTF_PROTO1 = Flags(.RTF_PROTO1)
        
        public static let RTF_PRCLONING = Flags(.RTF_PRCLONING)
        public static let RTF_WASCLONED = Flags(.RTF_WASCLONED)
        public static let RTF_PROTO3 = Flags(.RTF_PROTO3)
        
        public static let RTF_PINNED = Flags(.RTF_PINNED)
        public static let RTF_LOCAL = Flags(.RTF_LOCAL)
        public static let RTF_BROADCAST = Flags(.RTF_BROADCAST)
        public static let RTF_MULTICAST = Flags(.RTF_MULTICAST)
        public static let RTF_IFSCOPE = Flags(.RTF_IFSCOPE)
        public static let RTF_CONDEMNED = Flags(.RTF_CONDEMNED)
        public static let RTF_IFREF = Flags(.RTF_IFREF)
        public static let RTF_PROXY = Flags(.RTF_PROXY)
        public static let RTF_ROUTER = Flags(.RTF_ROUTER)
        
        /// e.g. Ethernet or Wi-Fi
        public static let availableNetwork: Flags = [.RTF_UP, .RTF_GATEWAY, .RTF_STATIC]
        
        /// route.h
        public enum Flag: Int32 {
            case RTF_UP = 0x1 /* route usable */
            case RTF_GATEWAY = 0x2 /* destination is a gateway */
            case RTF_HOST = 0x4 /* host entry (net otherwise) */
            case RTF_REJECT = 0x8 /* host or net unreachable */
            case RTF_DYNAMIC = 0x10 /* created dynamically (by redirect) */
            case RTF_MODIFIED = 0x20 /* modified dynamically (by redirect) */
            case RTF_DONE = 0x40 /* message confirmed */
            case RTF_DELCLONE = 0x80 /* delete cloned route */
            case RTF_CLONING = 0x100 /* generate new routes on use */
            case RTF_XRESOLVE = 0x200 /* external daemon resolves name */
            case RTF_LLINFO = 0x400 /* generated by link layer (e.g. ARP) */
            case RTF_STATIC = 0x800 /* manually added */
            case RTF_BLACKHOLE = 0x1000 /* just discard pkts (during updates) */
            case RTF_NOIFREF = 0x2000 /* not eligible for RTF_IFREF */
            case RTF_PROTO2 = 0x4000 /* protocol specific routing flag */
            case RTF_PROTO1 = 0x8000 /* protocol specific routing flag */
            
            case RTF_PRCLONING = 0x10000 /* protocol requires cloning */
            case RTF_WASCLONED = 0x20000 /* route generated through cloning */
            case RTF_PROTO3 = 0x40000 /* protocol specific routing flag */
            /* 0x80000 unused */
            case RTF_PINNED = 0x100000 /* future use */
            case RTF_LOCAL = 0x200000 /* route represents a local address */
            case RTF_BROADCAST = 0x400000 /* route represents a bcast address */
            case RTF_MULTICAST = 0x800000 /* route represents a mcast address */
            case RTF_IFSCOPE = 0x1000000 /* has valid interface scope */
            case RTF_CONDEMNED = 0x2000000 /* defunct; no longer modifiable */
            case RTF_IFREF = 0x4000000 /* route holds a ref to interface */
            case RTF_PROXY = 0x8000000 /* proxying, no interface scope */
            case RTF_ROUTER = 0x10000000 /* host is a router */
            /* 0x20000000 and up unassigned */
        }
    }
}

extension RoutingMessage: CustomStringConvertible {
    /// A human-readable description of the sort descriptor.
    public var description: String {
        /*
        return "RoutingMessage(" + "\n" +
            "\t" + "name: \(name)," + "\n" +
            "\t" + "flags: \(flags)," + "\n" +
            "\t" + "destination: \(destination)," + "\n" +
            (gateway.map { "\t" + "gateway: \($0)," + "\n" } ?? "") +
            (netmask.map { "\t" + "gateway: \($0)," + "\n" } ?? "") +
            (cloning.map { "\t" + "gateway: \($0)," + "\n" } ?? "") +
            (interfaceName.map { "\t" + "gateway: \($0)," + "\n" } ?? "") +
            (interface.map { "\t" + "gateway: \($0)," + "\n" } ?? "") +
            (authorOfRedirect.map { "\t" + "gateway: \($0)," + "\n" } ?? "") +
            (broadcast.map { "\t" + "gateway: \($0)," + "\n" } ?? "") +
        ")"
         */
        
        return "RoutingMessage(" + "\n" +
            "\t" + "name: \(name)," + "\n" +
            "\t" + "flags: \(flags)," + "\n" +
            "\t" + "destination: \(destination)," + "\n" +
            (gateway == nil ? "" : "\t" + "gateway: \(gateway!)," + "\n") +
            (netmask == nil ? "" : "\t" + "netmask: \(netmask!)," + "\n") +
            (cloning == nil ? "" : "\t" + "cloning: \(cloning!)," + "\n") +
            (interfaceName == nil ? "" : "\t" + "interfaceName: \(interfaceName!)," + "\n") +
            (interface == nil ? "" : "\t" + "interface: \(interface!)," + "\n") +
            (authorOfRedirect == nil ? "" : "\t" + "authorOfRedirect: \(authorOfRedirect!)," + "\n") +
            (broadcast == nil ? "" : "\t" + "broadcast: \(broadcast!)," + "\n") +
        ")"
    }
}

extension RoutingMessage.Flags: CustomStringConvertible {
    /// A human-readable description of the sort descriptor.
    public var description: String {
        var i: Int32 = 0
        return "[" +
            sequence(first: Flag(rawValue: 1 << i)!, next: { _ in
                i += 1;
                return Flag(rawValue: 1 << i)
            })
                .compactMap { contains(RoutingMessage.Flags($0)) ? $0 : nil }
                .compactMap { $0.description }
                .joined(separator: ", ")
            + "]"
    }
}

extension RoutingMessage.Flags.Flag: CustomStringConvertible {
    /// A human-readable description of the sort descriptor.
    public var description: String {
        switch self {
        case .RTF_UP: return "RTF_UP"
        case .RTF_GATEWAY: return "RTF_GATEWAY"
        case .RTF_HOST: return "RTF_HOST"
        case .RTF_REJECT: return "RTF_REJECT"
        case .RTF_DYNAMIC: return "RTF_DYNAMIC"
        case .RTF_MODIFIED: return "RTF_MODIFIED"
        case .RTF_DONE: return "RTF_DONE"
        case .RTF_DELCLONE: return "RTF_DELCLONE"
        case .RTF_CLONING: return "RTF_CLONING"
        case .RTF_XRESOLVE: return "RTF_XRESOLVE"
        case .RTF_LLINFO: return "RTF_LLINFO"
        case .RTF_STATIC: return "RTF_STATIC"
        case .RTF_BLACKHOLE: return "RTF_BLACKHOLE"
        case .RTF_NOIFREF: return "RTF_NOIFREF"
        case .RTF_PROTO2: return "RTF_PROTO2"
        case .RTF_PROTO1: return "RTF_PROTO1"
            
        case .RTF_PRCLONING: return "RTF_PRCLONING"
        case .RTF_WASCLONED: return "RTF_WASCLONED"
        case .RTF_PROTO3: return "RTF_PROTO3"
            
        case .RTF_PINNED: return "RTF_PINNED"
        case .RTF_LOCAL: return "RTF_LOCAL"
        case .RTF_BROADCAST: return "RTF_BROADCAST"
        case .RTF_MULTICAST: return "RTF_MULTICAST"
        case .RTF_IFSCOPE: return "RTF_IFSCOPE"
        case .RTF_CONDEMNED: return "RTF_CONDEMNED"
        case .RTF_IFREF: return "RTF_IFREF"
        case .RTF_PROXY: return "RTF_PROXY"
        case .RTF_ROUTER: return "RTF_ROUTER"
        }
    }
    
    /// [NETSTAT(1)](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/netstat.1.html)
    public var letter: String {
        switch self {
        case .RTF_UP: return "U"
        case .RTF_GATEWAY: return "G"
        case .RTF_HOST: return "H"
        case .RTF_REJECT: return "R"
        case .RTF_DYNAMIC: return "D"
        case .RTF_MODIFIED: return "M"
            //case .RTF_DONE: return
        //case .RTF_DELCLONE: return
        case .RTF_CLONING: return "C"
        case .RTF_XRESOLVE: return "X"
        case .RTF_LLINFO: return "L"
        case .RTF_STATIC: return "S"
        case .RTF_BLACKHOLE: return "B"
        //case .RTF_NOIFREF: return
        case .RTF_PROTO2: return "2"
        case .RTF_PROTO1: return "1"
            
        case .RTF_PRCLONING: return "c"
        case .RTF_WASCLONED: return "W"
        case .RTF_PROTO3: return "3"
            
            //case .RTF_PINNED: return
        //case .RTF_LOCAL: return
        case .RTF_BROADCAST: return "b"
        case .RTF_MULTICAST: return "m"
        case .RTF_IFSCOPE: return "I"
        //case .RTF_CONDEMNED: return
        case .RTF_IFREF: return "i"
        case .RTF_PROXY: return "Y"
        case .RTF_ROUTER: return "r"
        default: return "?"
        }
    }
}
