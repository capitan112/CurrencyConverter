//
//  GoodsTableVC.swift
//  R3piApp
//
//  Created by Капитан on 20.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import UIKit

class GoodsTableVC: UITableViewController {
    
    let currencySegue = "CurrencySegue"
    let cellID = "CellID"
    var items = [Goods]()
    var addedGoods = [(indexPath: Int, goods: Goods)]()
    var currencyRate: CurrencyRates?
    var presenter: ViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Goods"
        
        let dataParser = DataParser(dataLoader: DataLoader())
        presenter = ViewPresenter(dataParser: dataParser)
        populateGoods()
    }
    
    func populateGoods() {
        let peas = Goods(title: "Peas", price: 0.95, pack: .bag)
        let eggs = Goods(title: "Eggs", price: 2.10, pack: .dozen)
        let milk = Goods(title: "Milk", price: 1.30, pack: .bottle)
        let beans = Goods(title: "Beans", price: 0.73, pack: .can)
        items.append(peas)
        items.append(eggs)
        items.append(milk)
        items.append(beans)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! GoodsTableViewCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.priceLabel.text = "USD " + String(format: "%.2f", items[indexPath.row].price)
        cell.packLabel.text = "per " + items[indexPath.row].pack.rawValue
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(GoodsTableVC.addToBasket(sender:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(GoodsTableVC.removeFromBasket(sender:)), for: .touchUpInside)
        let filteredItems = addedGoods.filter({$0.indexPath == indexPath.row })
        
        if (filteredItems.count > 0) {
            cell.removeButton.isEnabled = true
        } else {
            cell.removeButton.isEnabled = false
        }
        cell.itemsInBasketLabel.text = String(filteredItems.count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sum = presenter.summaryItems(goods: addedGoods, currencyRate: currencyRate)
        let formatedSummed = presenter.formatCurrency(currency: sum)
        
        if self.currencyRate != nil {
            return "Total: " + (currencyRate?.currencyPair)! + " " + formatedSummed
        } else {
            return "Total: USD " + formatedSummed
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == currencySegue) {
            let currencyTableVC = segue.destination as! CurrencyTableVC
            currencyTableVC.delegate = self
            currencyTableVC.presenter = presenter
        }
    }
    
    // MARK: - Custom function for basket
    
    @objc func addToBasket(sender: UIButton) {
        let addedItem = (sender.tag, items[sender.tag])
        addedGoods.append(addedItem)
        self.tableView.reloadData()
    }
    
    @objc func removeFromBasket(sender: UIButton) {
        for index in 0..<addedGoods.count {
            if addedGoods[index].indexPath == sender.tag {
                addedGoods.remove(at: index)
                self.tableView.reloadData()
                return
            }
        }
        self.tableView.reloadData()
    }
}

extension GoodsTableVC:CurrencyTableVCProtocol {
    func getRate(rate: CurrencyRates?) {
        self.currencyRate = rate
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}
