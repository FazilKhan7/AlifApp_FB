//
//  LanguagesTableViewController.swift
//  PrayTime
//
//  Created by Bakhtiyarov Fozilkhon on 21.12.2022.
//

import UIKit

class LanguagesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "Русский"
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension String {
    func localizableString(loc: String) -> String {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")!
        let bundle = Bundle(path: path)
        return NSLocalizedString(self,tableName: nil ,bundle: bundle!,value: "" ,comment: "")
    }
}
