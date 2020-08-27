//
//  WhoisManager.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import Foundation
import Networking
import SwiftyJSON

class WhoisManager: ObservableObject {
    @Published var response: String = ""
    @Published var error = false
    
    let whoisURL = "https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey=\(Constants.xmlAPIKey)&outputFormat=JSON"
    
    func fetchWhois(domainName: String) {
        let urlString = "\(whoisURL)&domainName=\(domainName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        let networking = Networking(baseURL: urlString)
        networking.get("/get") { result in
            switch result {
            case .success(let response):
                let json = response.dictionaryBody
                let finalJson = JSON(json)
                if let whoisRawText = finalJson["WhoisRecord"]["rawText"].string {
                    self.response = whoisRawText
                    print(whoisRawText)
                    self.error = false
                }
                else {
                    print(finalJson["WhoisRecord"]["rawText"].error!)
                    self.error = true
                }
            case .failure(let response):
                print(response)
            }
        }
    }
}
