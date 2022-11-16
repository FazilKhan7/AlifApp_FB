//
//  ViewController.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var direction: UILabel!
    
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    
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
    
    
    func changePrayTimeView() {
        view1.layer.cornerRadius = 20
        view2.layer.cornerRadius = 20
        view3.layer.cornerRadius = 20
        view4.layer.cornerRadius = 20
        view5.layer.cornerRadius = 20
        view6.layer.cornerRadius = 20
    }
    
    func updateInterface(prayTime: PrayTime) {
        
        DispatchQueue.main.async {
            self.updateCityName()
            
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
    
    func updateInterface(currentCity: CurrentCity) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = String(currentCity.city)
            print(currentCity.city)
        }
    }
    
    func updateDirection(currentQibla: CurrentQiblaDirection) {
        DispatchQueue.main.async {
            self.direction.text = String(currentQibla.direction)
            print("DDDDDDDDDdirection \(currentQibla.direction)")
        }
    }
    
    func updateCityName() {
        networkPrayTimeManager.onCompletion2 = {[weak self] currentCity in
            guard let self = self else {return}
            self.updateInterface(currentCity: currentCity)
            
            self.networkPrayTimeManager.onCompletion3 = {[weak self] currentDirection in
                guard let self = self else {return}
                self.updateDirection(currentQibla: currentDirection)
            }
        }
        
    }
    
    //MARK: - _-_-_-_-_-_-_-_-_-_-

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
        changePrayTimeView()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        networkPrayTimeManager.onCompletion = {[weak self] prayTime in
            guard let self = self else {return}
            self.updateInterface(prayTime: prayTime)
        }
        
        self.networkPrayTimeManager.onCompletion3 = {[weak self] currentDirection in
            guard let self = self else {return}
            self.updateDirection(currentQibla: currentDirection)
        }
        
        
        
    }

    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) {  [unowned self] cityName, coutryName in
            self.networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .cityCountryName(city: cityName, country: coutryName))
            
            networkPrayTimeManager.onCompletion = {[weak self] prayTime in
                guard let self = self else {return}
                self.updateInterface(prayTime: prayTime)
                
                self.networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .currentCityName(latitude: prayTime.latitude, longitude: prayTime.longitude))

                self.networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .qiblaDirection(latitude: prayTime.latitude, longitude: prayTime.longitude))
            }
        }
        
    }
    
    
    @IBAction func myLocationPressed(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            updateCityName()
        }
    }

}



//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .coordinate(latitude: latitude, longitude: longitude))
        
        networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .currentCityName(latitude: latitude, longitude: longitude))
        
        networkPrayTimeManager.fetchCurrentPrayTime(forRequestTime: .qiblaDirection(latitude: latitude, longitude: longitude))
        
        updateCityName()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
}
