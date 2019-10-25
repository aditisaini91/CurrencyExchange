//
//  SelectSecondCurrencyVC.swift
//  CurrencyExchange
//

import UIKit

class SelectSecondCurrencyVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    private var selectedCurrency : String = ""
    var firstCurrency : String = ""
    var currencyList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if segue.destination is ViewController{
            let viewController = segue.destination as? ViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                selectedCurrency = currencyList[indexPath.row]
            }
            viewController?.currencyPair = "\(firstCurrency)\(selectedCurrency)"
        }
    }
    
}
