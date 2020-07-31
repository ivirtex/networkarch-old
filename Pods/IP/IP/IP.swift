//
//  IP.swift
//  IP
//
//  Created by Yu Sugawara on 2/3/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import Foundation

public struct IP {
    
    public enum Version: String {
        case IPv4, IPv6
        
        public init?(family: sa_family_t) {
            switch family {
            case UInt8(AF_INET):
                self = .IPv4
            case UInt8(AF_INET6):
                self = .IPv6
            default:
                return nil
            }
        }
    }
    
    public let version: Version
    public let address: String
    public let port: UInt16
    
    public init(version: Version, address: String, port: UInt16) throws {
        let regex = try NSRegularExpression(pattern: "^\(version.addressRegexPattern)$")
        
        guard regex.firstMatch(in: address,
                               range: NSRange(location: 0,
                                              length: address.count)) != nil else
        {
            throw IPError.invalidAddress(address)
        }
        
        self.version = version
        self.address = address
        self.port = port
    }
    
    public init(_ socketPtr: UnsafeMutablePointer<sockaddr>) throws {
        guard let version = Version(family: socketPtr.pointee.sa_family) else {
            throw IPError.unsupportedAddressFamily(socketPtr.pointee.sa_family)
        }
        
        guard let ipInfo: (String, UInt16) = {
            var address: Any
            let port: UInt16
            
            switch version {
            case .IPv4:
                let socket = socketPtr.withMemoryRebound(to: sockaddr_in.self,
                                                         capacity: 1,
                                                         { $0.pointee })
                address = socket.sin_addr
                port = socket.sin_port.bigEndian
            case .IPv6:
                let socket = socketPtr.withMemoryRebound(to: sockaddr_in6.self,
                                                         capacity: 1,
                                                         { $0.pointee })
                address = socket.sin6_addr
                port = socket.sin6_port.bigEndian
            }
            
            var buffer = [CChar](repeating: 0, count: Int(version.length))
            inet_ntop(version.type, &address, &buffer, socklen_t(version.length))
            guard let ipAddress = String(validatingUTF8: buffer) else {
                return nil
            }
            return (ipAddress, port)
            }() else {
                throw IPError.invalidAddress("nil")
        }
        
        try self.init(version: version, address: ipInfo.0, port: ipInfo.1)
    }
}

extension IP: Hashable {
    public static func ==(lhs: IP, rhs: IP) -> Bool {
        return lhs.version == rhs.version
            && lhs.address == rhs.address
            && lhs.port == rhs.port
    }
    
    public var hashValue: Int {
        return version.hashValue ^ address.hashValue ^ port.hashValue
    }
}

extension IP.Version {
    public var type: Int32 {
        switch self {
        case .IPv4:
            return AF_INET
        case .IPv6:
            return AF_INET6
        }
    }
    
    public var length: Int32 {
        switch self {
        case .IPv4:
            return INET_ADDRSTRLEN
        case .IPv6:
            return INET6_ADDRSTRLEN
        }
    }
}

extension IP.Version {
    
    public var addressRegexPattern: String {
        switch self {
        case .IPv4:
            return IP.Version.IPv4AddressRegexPattern
        case .IPv6:
            return IP.Version.IPv6AddressRegexPattern
        }
    }
    
    /**
     [IPv4](https://en.wikipedia.org/wiki/IPv4)
     
     ABNF: `dec-octet "." dec-octet "." dec-octet "." dec-octet`
     e.g.: `192.168.1.2`
     
     [RFC-3986 URI component: IPv4address](https://www.ietf.org/rfc/rfc3986.txt)
     [Regular Expression URI Validation](http://jmrware.com/articles/2009/uri_regexp/URI_regex.html
     */
    public static let IPv4AddressRegexPattern = [
        "(?:",
        "(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
        "\\.",
        "){3}",
        "(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
        ].reduce("", +)
    
    /**
     [IPv6](https://en.wikipedia.org/wiki/IPv6)
     
     ABNF:
     6( h16 ":" ) ls32
     /                       "::" 5( h16 ":" ) ls32
     / [               h16 ] "::" 4( h16 ":" ) ls32
     / [ *1( h16 ":" ) h16 ] "::" 3( h16 ":" ) ls32
     / [ *2( h16 ":" ) h16 ] "::" 2( h16 ":" ) ls32
     / [ *3( h16 ":" ) h16 ] "::"    h16 ":"   ls32
     / [ *4( h16 ":" ) h16 ] "::"              ls32
     / [ *5( h16 ":" ) h16 ] "::"              h16
     / [ *6( h16 ":" ) h16 ] "::"
     
     e.g.: `2001:0db8:85a3:0000:0000:8a2e:0370:7334`, `2001:db8:85a3:0:0:8a2e:370:7334`, `2001:db8:85a3::8a2e:370:7334`
     
     [RFC-3986 URI component:  IPv6address](https://www.ietf.org/rfc/rfc3986.txt)
     [Regular Expression URI Validation](http://jmrware.com/articles/2009/uri_regexp/URI_regex.html)
     */
    public static let IPv6AddressRegexPattern = [
        "(?:",
        "(?:(?:[0-9A-Fa-f]{1,4}:){6}",
        "|::(?:[0-9A-Fa-f]{1,4}:){5}",
        "|(?:[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){4}",
        "|(?:(?:[0-9A-Fa-f]{1,4}:){0,1}[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){3}",
        "|(?:(?:[0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){2}",
        "|(?:(?:[0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})?::[0-9A-Fa-f]{1,4}:",
        "|(?:(?:[0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})?::)",
        "(?:",
        "[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}",
        "|(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}",
        "(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
        ")",
        "|(?:(?:[0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})?::[0-9A-Fa-f]{1,4}",
        "|(?:(?:[0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})?::",
        ")"
        ].reduce("", +)
}

//extension IP.Version: Hashable {
//    
//    public static func ==(lhs: IP.Version, rhs: IP.Version) -> Bool {
//        return lhs == rhs
//    }
//}


extension IP.Version: CustomStringConvertible {
    /// A human-readable description of the sort descriptor.
    public var description: String {
        return rawValue
    }
}
