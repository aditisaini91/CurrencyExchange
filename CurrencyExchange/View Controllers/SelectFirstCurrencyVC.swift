//
//  SelectFirstCurrencyVC.swift
//  CurrencyExchange
//

import UIKit

class SelectFirstCurrencyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var currencyList : [String] = []
    private var selectedCurrency : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "currencies", ofType: "json") {
            currencyList = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: path)), options: JSONSerialization.ReadingOptions()) as! [String]
        }
    }
    
    //MARK: Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = currencyList[indexPath.row]
        return cell
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SelectSecondCurrencyVC {
            if let indexPath = tableView.indexPathForSelectedRow{
                selectedCurrency = currencyList[indexPath.row]
            }
            viewController.currencyList = currencyList.filter{$0 != selectedCurrency}
            viewController.firstCurrency = selectedCurrency
        }
    }
    
}
