//
//  ExtensionViewController.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import UIKit

extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String, String) -> Void) {
        

        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        
        ac.addTextField { tf in
            tf.placeholder = "Country name"
        }
        
        ac.addTextField { tf in
            tf.placeholder = "City name"
        }
        
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField1 = ac.textFields?.first
            let textField2 = ac.textFields?.last
            guard let cityName = textField2?.text else { return }
            guard let countryName = textField1?.text else { return }
            if cityName != "" && countryName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                let country = countryName.split(separator: " ").joined(separator: "%20")
                completionHandler(country, city)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)

        
    }
}
