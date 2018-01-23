//
//  DataParser.swift
//  R3piApp
//
//  Created by Капитан on 20.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

protocol DataParserProtocol {
    func parseCurrencyJSON(completion: @escaping (_ currencyRates: [CurrencyRates]?, _ error: Error?) -> Void)
}

enum ParseError: Error {
    case lostDataInParse
}

import Foundation

class DataParser : DataParserProtocol {
    
    internal let ratesURL = "http://www.apilayer.net/api/live?access_key=9b73664ece6a6161227f6cef3a2a5d3b"
    var dataLoader: DataLoaderProtocol!

    init(dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
    func parseCurrencyJSON(completion: @escaping (_ currencyRates: [CurrencyRates]?, _ error: Error?) -> Void) {
        dataLoader.loadDataFromURL(path: ratesURL, completion: { data, error in
            if (error == nil) {
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String:Any],
                        let currency = json["quotes"] as? [String:Any] {
                            var currencyRates = [CurrencyRates]()
                            for (key, value) in currency {
//                                let currency = String(key.characters.dropFirst(3))
                                let currency = String(key.dropFirst(3))
                                let pair = CurrencyRates(currencyPair: currency, rate: value as! Double)
                                currencyRates.append(pair)
                            }
                            completion(currencyRates, nil)
                    }
                    
                } catch {
                    completion(nil, error)
                    print ("Could not parse the data as JSON: '\(String(describing: data))'")}
            } else {
                print ("Error when loading '\(String(describing: error?.localizedDescription))'")
            }
        })
        
    }
}
