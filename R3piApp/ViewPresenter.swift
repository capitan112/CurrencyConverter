//
//  ViewPresenter.swift
//  R3piApp
//
//  Created by Капитан on 20.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//
import Foundation

class ViewPresenter {
    
    var dataParser: DataParserProtocol!
    // Dependency injection
    init(dataParser: DataParserProtocol) {
        self.dataParser = dataParser
    }
    
    func parseCurrencyJSON(completion: @escaping (_ currencyRates: [CurrencyRates]?, _ error: Error?) -> Void) {
        dataParser.parseCurrencyJSON(completion: { currencyRates, error in
            completion (currencyRates, error)
        })
    }
    
    func summaryItems(goods: [(indexPath: Int, goods: Goods)], currencyRate: CurrencyRates?) -> Double {
        let total = goods.map {$0.goods.price}.reduce(0){ $0 + $1 }
        if let currencyRate = currencyRate?.rate {
            return total * currencyRate
        } else {
            return total
        }
    }
    
    func formatCurrency(currency: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: currency as NSNumber)!
    }
}



