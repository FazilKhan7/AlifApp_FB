//
//  QiblaDirectionViewController.swift
//  PrayTime
//
//  Created by Bakhtiyarov Fozilkhon on 16.12.2022.
//

import UIKit

class QiblaDirectionViewController: UIViewController {
    
    @IBOutlet weak var qiblaDirection: UILabel!
    @IBOutlet weak var imageDirection: UIImageView!
    
    var drt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endOfSentence = drt.firstIndex(of: ".")
        let firstSentence = drt[...endOfSentence!]
        qiblaDirection.text = "Direction of Kibla \(firstSentence)0 °"
        UIView.animate(withDuration: 2.0, animations: { [self] in
            imageDirection.transform = CGAffineTransform(rotationAngle: (CGFloat(Double(drt)!) * .pi) / 180.0)
        })
    }
    
    @IBAction func backPage(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func liveScreen(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.youtube.com/watch?v=dGTEfbdZNv4")!, options: [:], completionHandler: nil)
    }
}
