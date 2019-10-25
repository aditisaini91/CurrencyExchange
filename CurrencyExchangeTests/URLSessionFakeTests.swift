//
//  URLSessionFakeTests.swift
//  CurrencyExchangeTests
//


import XCTest

@testable import CurrencyExchange

class URLSessionFakeTests: XCTestCase {
    var viewController: ViewController!
    
    override func setUp() {
        //initializing the viewcontroller
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController
        
        //creating fake json output
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "FakeTestJsonInput", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        //setting up the fake URLSession and injecting in the viewController NetworkManager
        let url = URL(string: "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?pairs=USDGBP&pairs=GBPUSD")
        let urlResponse = HTTPURLResponse(
            url: url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        
        viewController.networkManager = NetworkManager()
        viewController.networkManager?.defaultSession = sessionMock
        
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    func testParsesData() {
        let expectations = expectation(description: "Status code: 200")
        
        XCTAssertEqual(viewController.responseDictionary.count, 0, "No data at the beginning")
        
        let url = URL(string: "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?pairs=USDGBP&pairs=GBPUSD")
        let dataTask = viewController.networkManager?.defaultSession.dataTask(with: url!) {
            data, response, error in
            // if HTTP request is successful, call updateSearchResults(_:)
            // which parses the response data into Tracks
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        self.viewController.responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                    } catch let error as NSError {
                        print("JSONSerialization error: \(error.localizedDescription)")
                    }
                }
            }
            expectations.fulfill()
        }
        dataTask?.resume()
        wait(for: [expectations], timeout: 5)
        
        XCTAssertEqual(viewController.responseDictionary.count, 2, "Didn't parse 2 items from fake response")
    }
    
}
