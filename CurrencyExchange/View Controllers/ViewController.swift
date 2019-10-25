//
//  ViewController.swift
//  CurrencyExchange
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CurrencyValueUpdatedProtocol {
    var currencyPair: String = "" {
        didSet {
            if !currencyPairs.contains(currencyPair) {
                currencyPairs.append(currencyPair)
            }
        }
    }
    var currencyPairs :[String] = UserDefaults.standard.stringArray(forKey: "SavedCurrencyPairs") ?? [String](){
        didSet {
            UserDefaults.standard.set(currencyPairs, forKey: "SavedCurrencyPairs")
            networkManager?.updateURL(currencyPairs: currencyPairs)
        }
    }
    var responseDictionary : [String:AnyObject] = [:]   //from NetworkManager
    var networkManager : NetworkManager?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "CurrencyPairTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CurrencyPairTableViewCell")
        
        self.setupNetworkManager()
    }
    
    func setupNetworkManager(){
        networkManager = NetworkManager()
        networkManager?.delegate = self
        networkManager?.updateURL(currencyPairs: currencyPairs)
    }
    
    //MARK: Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyPairTableViewCell", for: indexPath) as! CurrencyPairTableViewCell
        let currencyPair : String = currencyPairs[indexPath.row]
        
        cell.firstCurrencyLabel.text = String(currencyPair.prefix(3))
        cell.secondCurrencyLabel.text = String(currencyPair.suffix(3))
        
        if let currencyValue : Double = responseDictionary[currencyPair] as? Double {
            cell.secondCurrencyLabel.text = "\(currencyValue.roundToDecimal(2)) \(String(currencyPair.suffix(3)))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currencyPairs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: Navigation
    @IBAction func unwindToViewController(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    //MARK: CurrencyValueUpdatedProtocol
    func responseuUpdated(responseDictionary: [String : AnyObject]) {
        self.responseDictionary = responseDictionary
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

