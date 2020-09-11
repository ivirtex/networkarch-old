//
//  DNSLookupView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct DNSLookupView: View {
    @ObservedObject private var dns = DNSManager()
    @State private var domainName: String = ""
    @State private var shouldDisplayList = false
    
    var body: some View {
        List {
            Section {
                SearchBar(text: $domainName, placeholder: "Domain Name")
            }
            if shouldDisplayList {
                if dns.networkingError == false && dns.jsonError == false {
                    if dns.areRecordsAvailable {
                        if let safeDomainName = dns.aDNSTypeDomainName, let safeTTL = dns.aDNSTypeTTL {
                            Section(header: Text("A Record")) {
                                ADNSTypeView(domainName: safeDomainName, address: dns.aDNSTypeAddress, ttl: safeTTL)
                            }
                        }
                        
                        if let safeDomainName = dns.aaaaDNSTypeDomainName, let safeTTL = dns.aaaaDNSTypeTTL {
                            Section(header: Text("AAAA Record")) {
                                AAAADNSTypeView(domainName: safeDomainName, address: dns.aaaaDNSTypeAddress, ttl: safeTTL)
                            }
                        }
                        
                        if let safeDomainName = dns.nsDNSTypeDomainName, let safeTTL = dns.nsDNSTypeTTL {
                            Section(header: Text("NS Record")) {
                                NSDNSTypeView(domainName: safeDomainName, target: dns.nsDNSTypeTarget, ttl: safeTTL)
                            }
                        }
                        
                        if let safeDomainName = dns.soaDNSTypeDomainName, let safeAdmin = dns.soaDNSTypeAdmin, let safeHost = dns.soaDNSTypeHost, let safeExpire = dns.soaDNSTypeExpire, let safeMin = dns.soaDNSTypeMinimum, let safeRefresh = dns.soaDNSTypeRefresh, let safeRetry = dns.soaDNSTypeRetry, let safeSerial = dns.soaDNSTypeSerial, let safeTTL = dns.soaDNSTypeTTL {
                            Section(header: Text("SOA Record")) {
                                SOADNSTypeView(domainName: safeDomainName, admin: safeAdmin, host: safeHost, expire: safeExpire, minimum: safeMin, refresh: safeRefresh, retry: safeRetry, serial: safeSerial, ttl: safeTTL)
                            }
                        }
                        
                        if let safeDomainName = dns.mxDNSTypeDomainName, let safeTTL = dns.mxDNSTypeTTL {
                            Section(header: Text("MX Record")) {
                                MXDNSTypeView(domainName: safeDomainName, target: dns.mxDNSTypeTarget, ttl: safeTTL)
                            }
                        }
                        
                        if let safeDomainName = dns.txtDNSTypeDomainName, let safeTTL = dns.txtDNSTypeTTL {
                            Section(header: Text("TXT Record")) {
                                TXTDNSTypeView(domainName: safeDomainName, strings: dns.txtDNSTypeStrings, ttl: safeTTL)
                            }
                        }
                    }
                    else {
                        Section {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }
                else {
                    Section {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.white)
                            Spacer()
                            Text("Invalid domain")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .listRowBackground(Color(.systemRed))
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("DNS Lookup")
        .animation(.linear)
        .navigationBarItems(trailing: Button(action: {
            let finalDomain = domainName
            domainName = ""
            dns.areRecordsAvailable = false
            dns.networkingError = false
            dns.jsonError = false
            shouldDisplayList = true
            resetRecords()
            hideKeyboard()
            DispatchQueue.global().async {
                dns.fetchIP(domainName: finalDomain)
            }
        })
        {
            Text("Start")
                .accentColor(Color(.systemGreen))
        }
        .disabled(self.domainName.isEmpty)
        )
    }
    
    func resetRecords() {
        dns.aDNSTypeDomainName = nil
        dns.aDNSTypeAddress = ""
        dns.aDNSTypeTTL = nil
        
        dns.aaaaDNSTypeDomainName = nil
        dns.aaaaDNSTypeAddress = ""
        dns.aaaaDNSTypeTTL = nil
        
        dns.nsDNSTypeDomainName = nil
        dns.nsDNSTypeTarget = ""
        dns.nsDNSTypeTTL = nil
        
        dns.soaDNSTypeTTL = nil
        dns.soaDNSTypeSerial = nil
        dns.soaDNSTypeRetry = nil
        dns.soaDNSTypeRefresh = nil
        dns.soaDNSTypeMinimum = nil
        dns.soaDNSTypeExpire = nil
        dns.soaDNSTypeHost = nil
        dns.soaDNSTypeAdmin = nil
        dns.soaDNSTypeDomainName = nil
        
        dns.mxDNSTypeDomainName = nil
        dns.mxDNSTypeTarget = ""
        dns.mxDNSTypePriority = ""
        dns.mxDNSTypeTTL = nil
        
        dns.txtDNSTypeDomainName = nil
        dns.txtDNSTypeStrings = ""
        dns.txtDNSTypeTTL = nil
    }
}

struct DNSLookupView_Previews: PreviewProvider {
    static var previews: some View {
        DNSLookupView()
    }
}
