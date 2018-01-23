//
//  GoodsTableVCTest.swift
//  R3piApp
//
//  Created by Капитан on 21.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import XCTest
@testable import R3piApp

class GoodsTableVCTest: XCTestCase {
    var sut: GoodsTableVC!
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        sut = storyBoard.instantiateViewController(withIdentifier: "GoodsTableVC") as! GoodsTableVC
        _ = sut.view
        sut.title = "Goods"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGoodsTableVCFormat_ShouldReturnNumberFormat() {
            let currency = sut.presenter.formatCurrency(currency: 100)
            XCTAssertNotEqual(currency, "110.00")
            XCTAssertEqual(currency, "100.00")
    }
    
    func testGoodsTableVCFormat_ShouldReturnThousandFormat() {
        let currency = sut.presenter.formatCurrency(currency: 9999.124)
        XCTAssertNotEqual(currency, "1110.00")
        XCTAssertEqual(currency, "9,999.12")
    }
    
    func testGoodsTableVCItemsGoods_ShouldReturnNumberOfItem() {
        XCTAssertTrue(sut.items.count > 0)
        XCTAssertEqual(sut.items.count, 4)
        
    }
    
    func testGoodsTableVCAddedGoods_ShouldReturnNumberOfItems() {
        let peas = Goods(title: "Peas", price: 0.95, pack: .bag)
        let addedItem = (0, peas)
        sut.addedGoods.append(addedItem)
        XCTAssertTrue(sut.addedGoods.count > 0)
        XCTAssertEqual(sut.addedGoods.count, 1)
    }
    
    func testGoodsTableVCRemoveGoods_ShouldReturnNumberOfItems() {
        let peas = Goods(title: "Peas", price: 0.95, pack: .bag)
        let eggs = Goods(title: "Eggs", price: 2.10, pack: .dozen)

        let addedItemPeas = (0, peas)
        let addedItemEggs = (0, eggs)
        sut.addedGoods.append(addedItemPeas)
        sut.addedGoods.append(addedItemEggs)
        sut.addedGoods.append(addedItemEggs)
        sut.addedGoods.remove(at: 0)
        XCTAssertTrue(sut.addedGoods.count > 0)
    }
    
    func testGoodsTableVCSummaryItems_ShouldReturnSum() {
        let peas = Goods(title: "Peas", price: 0.95, pack: .bag)
        let eggs = Goods(title: "Eggs", price: 2.10, pack: .dozen)
        let addedItemPeas = (0, peas)
        let addedItemEggs = (0, eggs)
        sut.addedGoods.append(addedItemPeas)
        sut.addedGoods.append(addedItemEggs)
        sut.addedGoods.append(addedItemEggs)
        
        sut.currencyRate = nil
        var sum = sut.presenter.summaryItems(goods: sut.addedGoods, currencyRate: sut.currencyRate)
        XCTAssertEqual(sum, 5.15)
        
        sut.currencyRate = CurrencyRates(currencyPair: "BBD", rate: 2)
        sum = sut.presenter.summaryItems(goods: sut.addedGoods, currencyRate: sut.currencyRate)
        XCTAssertEqual(sum, 10.3)
        
        sut.currencyRate = CurrencyRates(currencyPair: "ALL", rate: 125.8)
        sum = sut.presenter.summaryItems(goods: sut.addedGoods, currencyRate: sut.currencyRate)
        XCTAssertEqual(sum, 647.87)
        
        sut.currencyRate = CurrencyRates(currencyPair: "AOA", rate: 165.085)
        sum = sut.presenter.summaryItems(goods: sut.addedGoods, currencyRate: sut.currencyRate)
        XCTAssertEqual(sum, 850.18775)
    }

}
