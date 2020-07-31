//
//  Host.swift
//  IP
//
//  Created by Yu Sugawara on 2/5/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import Foundation

public struct Host {
    public let name: String
    public let ipv4s: [IP]?
    public let ipv6s: [IP]?
    
    /// Get Host struct, included host name and IPs.
    /// [getaddrinfo, freeaddrinfo](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/getaddrinfo.3.html)
    ///
    /// - Returns: Host
    /// - Throws: POSIX error
    public static func current() throws -> Host {
        var cHostName = Array<Int8>(repeating: 0, count: Int(_POSIX_HOST_NAME_MAX))
        do {
            // https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/gethostname.3.html
            let errno = gethostname(&cHostName, cHostName.count)
            if errno != 0 {
                throw POSIXErrorCode(rawValue: errno).map { IPError.posixError($0) } ?? IPError.unknown
            }
        }
        guard let hostName = String(validatingUTF8: cHostName) else {
            throw IPError.unknown
        }
        
        var buffer: UnsafeMutablePointer<addrinfo>?
        defer {
            if buffer != nil {
                freeaddrinfo(buffer)
            }
        }
        
        guard let addressInfo: UnsafeMutablePointer<addrinfo> = {
            var hints = addrinfo()
            hints.ai_flags = AI_ALL
            hints.ai_family = PF_UNSPEC
            hints.ai_socktype = SOCK_STREAM
            
            let errno = getaddrinfo(cHostName, "0" /* port */, &hints, &buffer)
            if errno != 0 {
                return nil
            }
            return buffer
            }() else {
                return Host(name: hostName, ipv4s: nil, ipv6s: nil)
        }
        
        var ipv4s = [IP]()
        var ipv6s = [IP]()
        
        sequence(first: addressInfo,
                 next: { $0.pointee.ai_next })
            .forEach { addressInfo in
                guard let socketPtr = UnsafeMutablePointer<sockaddr>(addressInfo.pointee.ai_addr) else { return }
                guard let ip = try? IP(socketPtr) else { return }
                switch ip.version {
                case .IPv4: ipv4s.append(ip)
                case .IPv6: ipv6s.append(ip)
                }
        }
        
        return Host(name: hostName,
                    ipv4s: Array(Set(ipv4s)),
                    ipv6s: Array(Set(ipv6s)))
    }
}
