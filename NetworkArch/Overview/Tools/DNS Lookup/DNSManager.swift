//
//  DNSManager.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 13/08/2020.
//

import Foundation
import Networking
import SwiftyJSON

class DNSManager: ObservableObject {
    @Published var networkingError = false
    @Published var jsonError = false
    @Published var areRecordsAvailable = false

    @Published var aDNSTypeDomainName: String?
    @Published var aDNSTypeAddress = ""
    @Published var aDNSTypeTTL: Int?

    @Published var aaaaDNSTypeDomainName: String?
    @Published var aaaaDNSTypeAddress = ""
    @Published var aaaaDNSTypeTTL: Int?

    @Published var nsDNSTypeDomainName: String?
    @Published var nsDNSTypeTarget = ""
    @Published var nsDNSTypeTTL: Int?

    @Published var soaDNSTypeDomainName: String?
    @Published var soaDNSTypeAdmin: String?
    @Published var soaDNSTypeHost: String?
    @Published var soaDNSTypeExpire: Int?
    @Published var soaDNSTypeMinimum: Int?
    @Published var soaDNSTypeRefresh: Int?
    @Published var soaDNSTypeRetry: Int?
    @Published var soaDNSTypeSerial: Int?
    @Published var soaDNSTypeTTL: Int?

    @Published var mxDNSTypeDomainName: String?
    @Published var mxDNSTypePriority = ""
    @Published var mxDNSTypeTarget = ""
    @Published var mxDNSTypeTTL: Int?

    @Published var txtDNSTypeDomainName: String?
    @Published var txtDNSTypeStrings = ""
    @Published var txtDNSTypeTTL: Int?

    let dnsUrl = "https://www.whoisxmlapi.com/whoisserver/DNSService?apiKey=\(Constants.xmlAPIKey)&type=_all&outputFormat=JSON"

    func fetchIP(domainName: String) {
        let urlString = "\(dnsUrl)&domainName=\(domainName)&"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        let networking = Networking(baseURL: urlString)
        networking.get("/get") { [self] result in
            switch result {
            case let .success(response):
                areRecordsAvailable = true
                networkingError = false
                jsonError = false
                let json = response.dictionaryBody
                let finalJson = JSON(json)
                if !finalJson["ErrorMessage"].exists() {
                    for item in finalJson["DNSData"]["dnsRecords"].arrayValue {
                        switch item["dnsType"].stringValue {
                        case "A":
                            self.aDNSTypeDomainName = item["name"].stringValue
                            self.aDNSTypeAddress.append(item["address"].stringValue + "\n")
                            self.aDNSTypeTTL = item["ttl"].intValue
                        case "AAAA":
                            self.aaaaDNSTypeDomainName = item["name"].stringValue
                            self.aaaaDNSTypeAddress.append(item["address"].stringValue + "\n")
                            self.aaaaDNSTypeTTL = item["ttl"].intValue
                        case "NS":
                            self.nsDNSTypeDomainName = item["name"].stringValue
                            self.nsDNSTypeTarget.append(item["target"].stringValue + "\n")
                            self.nsDNSTypeTTL = item["ttl"].intValue
                        case "SOA":
                            self.soaDNSTypeDomainName = item["name"].stringValue
                            self.soaDNSTypeAdmin = item["admin"].stringValue
                            self.soaDNSTypeHost = item["host"].stringValue
                            self.soaDNSTypeExpire = item["expire"].intValue
                            self.soaDNSTypeMinimum = item["minimum"].intValue
                            self.soaDNSTypeRefresh = item["refresh"].intValue
                            self.soaDNSTypeRetry = item["retry"].intValue
                            self.soaDNSTypeSerial = item["serial"].intValue
                            self.soaDNSTypeTTL = item["ttl"].intValue
                        case "MX":
                            self.mxDNSTypeDomainName = item["name"].stringValue
                            self.mxDNSTypeTarget.append(item["target"].stringValue + "\nPriority: " + String(item["priority"].intValue) + "\n\n")
                            self.mxDNSTypeTTL = item["ttl"].intValue
                        case "TXT":
                            self.txtDNSTypeDomainName = item["name"].stringValue
                            self.txtDNSTypeStrings.append(item["strings"][0].stringValue + "\n")
                            self.txtDNSTypeTTL = item["ttl"].intValue
                        default:
                            print("additional dns record")
                        }
                    }
                } else {
                    self.jsonError = true
                    print("dns error")
                }

            case let .failure(response):
                self.networkingError = true
                print(response)
            }
        }
    }
}
