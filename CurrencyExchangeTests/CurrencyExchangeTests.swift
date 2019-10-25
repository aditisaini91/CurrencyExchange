//
//  CurrencyExchanges.swift
//  CurrencyExchangeTests
//


import XCTest
@testable import CurrencyExchange

class CurrencyExchanges: XCTestCase {
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        urlSession = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        urlSession = nil
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToRevolutApi() {
        let url = URL(string: "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?pairs=USDGBP&pairs=GBPUSD")
        let expectations = expectation(description: "Status code: 200")
        
        let dataTask = urlSession.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    expectations.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [expectations], timeout: 5)
    }
    
    // Asynchronous test: success fast, failure fast
    func testValidCallToRevolutApiCompletes() {
        let url = URL(string: "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?pairs=USDGBP&pairs=GBPUSD")
        let expectations = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = urlSession.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            expectations.fulfill()
        }
        dataTask.resume()
        wait(for: [expectations], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
