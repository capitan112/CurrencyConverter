//
//  R3piAppTests.swift
//  R3piAppTests
//
//  Created by Капитан on 20.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import XCTest
@testable import R3piApp

class R3piAppServicesTests: XCTestCase {
    
    var timeOut:TimeInterval = 5
    var dataLoader: DataLoaderProtocol!
    var dataParser: DataParserProtocol!
    
    override func setUp() {
        super.setUp()
        dataLoader = DataLoader()
        dataParser = DataParser(dataLoader: dataLoader)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDataLoader_ShouldReturnNotNil() {
        let loader = expectation(description: "Loading data")
        
        let ratesURL = "http://www.apilayer.net/api/live?access_key=9b73664ece6a6161227f6cef3a2a5d3b"
        dataLoader.loadDataFromURL(path: ratesURL, completion: { data, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            loader.fulfill()
        })
        
        self.waitForExpectations(timeout: timeOut, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
    func testViewPresenter_ShouldReturnCurrencyRatesArray() {
        let loader = expectation(description: "Loading data")
        
        let dataParser = DataParser(dataLoader: DataLoader())
        let presenter = ViewPresenter(dataParser: dataParser)
        
        presenter.parseCurrencyJSON(completion: { currences, error in
            XCTAssertTrue((currences?.count)! > 0)
            
            loader.fulfill()
        })
        
        self.waitForExpectations(timeout: timeOut, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
    func testDataParser_ShouldReturnCurrencyRatesArray() {
        let loader = expectation(description: "Loading data")

        dataParser.parseCurrencyJSON(completion: { currences, error in
            XCTAssertTrue((currences?.count)! > 0)
            
            loader.fulfill()
        })
        
        self.waitForExpectations(timeout: timeOut, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
    func testDataParser_ShouldReturnCurrencyRatesFirstValaue() {
        let loader = expectation(description: "Loading data")
        
        dataParser.parseCurrencyJSON(completion: { currences, error in
            XCTAssertEqual(currences?.first?.currencyPair, "FJD")
            loader.fulfill()
        })
        
        self.waitForExpectations(timeout: timeOut, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
    func testDataParser_ShouldReturnCurrencyRatesLastValue() {
        let loader = expectation(description: "Loading data")
        
        dataParser.parseCurrencyJSON(completion: { currences, error in
            XCTAssertEqual(currences?.last?.currencyPair, "GEL")
            loader.fulfill()
        })
        
        self.waitForExpectations(timeout: timeOut, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
}
