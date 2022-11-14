//
//  ViewController.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    
    @IBOutlet weak var fajrLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var dhuhrLabel: UILabel!
    @IBOutlet weak var asrLabel: UILabel!
    @IBOutlet weak var ishaLabel: UILabel!
    @IBOutlet weak var maghribLabel: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    
    

    var networkPrayTimeManager = NetworkPrayTimeManager()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    @IBOutlet weak var searchButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //networkPrayTimeManager.delegate = self
        changePrayTimeView()
        
        networkPrayTimeManager.onCompletion = {[weak self] prayTime in
            guard let self = self else {return}
            self.updateInterface(prayTime: prayTime)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
//        networkPrayTimeManager.fetchCurrentPrayTime(forCity: "Kaskelen")
    }

    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) {  [unowned self] cityName in
            self.networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .cityName(city: cityName))
        }
    }
    
    func updateInterface(prayTime: PrayTime) {
        
        DispatchQueue.main.async {
            self.fajrLabel.text = "\(prayTime.fajr)"
            self.sunriseLabel.text = "\(prayTime.sunrise)"
            self.dhuhrLabel.text = "\(prayTime.dhuhr)"
            self.asrLabel.text = "\(prayTime.asr)"
            self.ishaLabel.text = "\(prayTime.isha)"
            self.maghribLabel.text = "\(prayTime.maghrib)"
            
            self.weekdayLabel.text = prayTime.weekday
            self.currentDate.text = prayTime.currentDate
        }

    }
    
    func changePrayTimeView() {
        view1.layer.cornerRadius = 20
        view2.layer.cornerRadius = 20
        view3.layer.cornerRadius = 20
        view4.layer.cornerRadius = 20
        view5.layer.cornerRadius = 20
        view6.layer.cornerRadius = 20
    }
    
}

//extension ViewController: PrayerTimeDelegate {
//    func updateInterface(_: NetworkPrayTimeManager, with prayerTime: PrayTime) {
//        <#code#>
//    }
//
//
//}


//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
