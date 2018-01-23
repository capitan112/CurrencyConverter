//
//  CarrencyTableVC.swift
//  R3piApp
//
//  Created by Капитан on 20.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//
protocol CurrencyTableVCProtocol {
    func getRate(rate: CurrencyRates?)
}

import UIKit

class CurrencyTableVC: UITableViewController {
    
    let cellID = "currencyCellID"
    var currencyRates = [CurrencyRates]()
    var delegate:CurrencyTableVCProtocol?
    var selectedItem: CurrencyRates?
    var presenter: ViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To USD Rate"
        performUIUpdatesOnMain {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        presenter.parseCurrencyJSON(completion: { currencyRates, error in
            if (error == nil) {
                if let currencyRates:[CurrencyRates] = currencyRates {
                
                    self.currencyRates = currencyRates
                        .sorted{String($0.currencyPair) < String($1.currencyPair) }
                    
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            
            performUIUpdatesOnMain {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            if selectedItem == nil {
                delegate?.getRate(rate: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyRates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = (currencyRates[indexPath.row].currencyPair)!
        let formatedRate = presenter.formatCurrency(currency: currencyRates[indexPath.row].rate)
        cell.detailTextLabel?.text = formatedRate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = currencyRates[indexPath.row]
        delegate?.getRate(rate: selectedItem)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
