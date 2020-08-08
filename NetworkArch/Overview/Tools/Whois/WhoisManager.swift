//
//  WhoisManager.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import Foundation

class WhoisManager: ObservableObject {
    @Published var error: NSObject?
    @Published var response: NSObject?
    
    let headers = [
        "x-rapidapi-host": "nettools.p.rapidapi.com",
        "x-rapidapi-key": "5c663e1b2dmshe202385e147402bp1a5e77jsncb6568671272"
    ]
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://nettools.p.rapidapi.com/whois/%7Bquery%7D")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    func fetchWhois() {
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        performRequest()
    }
    
    func performRequest() {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                self.error = error as NSObject?
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                DispatchQueue.main.async {
                    self.response = httpResponse
                }
            }
        })
        dataTask.resume()
    }
    
}
