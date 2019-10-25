//
//  NetworkManager.swift
//  CurrencyExchange
//


import Foundation


class NetworkManager {
    private let urlAPI : String = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?" 
    private var urlString : String = ""  
    var defaultSession : URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.default)
    private var dataTask:URLSessionDataTask?
    weak var delegate: CurrencyValueUpdatedProtocol?
    private var timer: Timer?
    private var responseDictionary : [String:AnyObject] = [:]{
        didSet{
            delegate?.responseuUpdated(responseDictionary: self.responseDictionary)
        }
    }
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func updateURL(currencyPairs :[String]){
        urlString = urlAPI
        for currencyPair in currencyPairs {
            urlString.append("pairs=\(currencyPair)&")
        }
    }
    
    @objc private func update(){
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                print("defaultSession dataTask error: \(error.localizedDescription)")
            }
            if let data = data {
                do {
                    self.responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                } catch let error as NSError {
                    print("JSONSerialization error: \(error.localizedDescription)")
                }
            }
        })
        dataTask?.resume()
    }
}
