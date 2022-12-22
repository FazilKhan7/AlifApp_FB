//
//  ViewController.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import UIKit
import CoreLocation
import UserNotifications

class CellClass: UITableViewCell {}

class ViewController: UIViewController {
    
    @IBOutlet weak var bckgImage: UIImageView!
    
    @IBOutlet weak var direction: UILabel!
    
    @IBOutlet weak var currentPray: UILabel!
    @IBOutlet weak var currentPrayTime: UILabel!
    
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
    
    @IBOutlet weak var selectedButton: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedBtn = UIButton()
    var dataSource = [String]()
    var directionOfQibla = ""
    var networkPrayTimeManager = NetworkPrayTimeManager()
    var isBool = true
    
    func changePrayTimeView() {
        view1.layer.cornerRadius = 20
        view2.layer.cornerRadius = 20
        view3.layer.cornerRadius = 20
        view4.layer.cornerRadius = 20
        view5.layer.cornerRadius = 20
        view6.layer.cornerRadius = 20
    }
    
    func transParentView(frames: CGRect){
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        tableView.frame = CGRect(x: frames.origin.x + 20, y: frames.origin.y + 550, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 20
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransParentView))
        transparentView.addGestureRecognizer(tapgesture)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0) { [self] in
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: (frames.origin.x + 20), y: frames.origin.y + 550, width: frames.width, height: CGFloat(dataSource.count * 50))
        }
    }
    
    @objc func removeTransParentView(){
        let frames = view1.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0) {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: (frames.origin.x + 20), y: frames.origin.y + 550, width: frames.width, height: 0)
        }
    }
    
    
    @IBAction func btnSelectedAction(_ sender: Any) {
        dataSource = ["📅 Upcoming Events", "🔢 Dhikr", "⚙️ Settings"]
        transParentView(frames: view1.frame)
    }
    
    @IBAction func qiblaDirection(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "qibla") as? QiblaDirectionViewController else{
            return
        }
        vc.drt = directionOfQibla
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
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
        DispatchQueue.main.async { [self] in
            directionOfQibla = String(currentQibla.direction)
            print("DDDDDDDDDdirection \(directionOfQibla)")
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
        
        
        direction.text = directionOfQibla
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "cell")
        changePrayTimeView()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        networkPrayTimeManager.onCompletion = {[weak self] prayTime in
            guard let self = self else {return}
            self.updateInterface(prayTime: prayTime)
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    self.notificationPray(fagr: prayTime.fajr, dhukr: prayTime.dhuhr, asr: prayTime.asr, isha: prayTime.isha, magrib: prayTime.maghrib)
                }
                else if error != nil {
                    print("error occurred")
                }
            })
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
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                    if success {
                        self.notificationPray(fagr: prayTime.fajr, dhukr: prayTime.dhuhr, asr: prayTime.asr, isha: prayTime.isha, magrib: prayTime.maghrib)
                    }
                    else if error != nil {
                        print("error occurred")
                    }
                })
                
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
    
    @IBAction func soundMuteClicked(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "volume.slash"), for: .normal)
        isBool = true
        if sender.imageView?.image == UIImage(systemName: "volume.slash") {
            sender.setImage(UIImage(systemName: "volume.1"), for: .normal)
        }else{
            isBool = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bckgImage.image = bckgImg
    }
    
    func notificationPray(fagr: String, dhukr: String, asr: String, isha: String, magrib: String){
        
        let content = UNMutableNotificationContent()
        print(isBool)
        if isBool == true {
            content.sound = .default
        }else{
            content.sound = .none
        }
        
        var dateComponents = DateComponents()
        let spl = fagr.components(separatedBy: ":")
        dateComponents.hour = Int(spl[0])
        dateComponents.minute = Int(spl[1])
        dateComponents.calendar = Calendar.current

        var dateComponents1 = DateComponents()
        let spl1 = dhukr.components(separatedBy: ":")
        dateComponents1.hour = Int(spl1[0])
        dateComponents1.minute = Int(spl1[1])
        dateComponents1.calendar = Calendar.current
        
        var dateComponents2 = DateComponents()
        let spl2 = asr.components(separatedBy: ":")
        dateComponents2.hour = Int(spl2[0])
        dateComponents2.minute = Int(spl2[1])
        dateComponents2.calendar = Calendar.current
        
        var dateComponents3 = DateComponents()
        let spl3 = isha.components(separatedBy: ":")
        dateComponents3.hour = Int(spl3[0])
        dateComponents3.minute = Int(spl3[1])
        dateComponents3.calendar = Calendar.current
        
        var dateComponents4 = DateComponents()
        let spl4 = magrib.components(separatedBy: ":")
        dateComponents4.hour = Int(spl4[0])
        dateComponents4.minute = Int(spl4[1])
        dateComponents4.calendar = Calendar.current
        
        let hours = (Calendar.current.component(.hour, from: Date()))
        let minut = (Calendar.current.component(.minute, from: Date()))
        
        if hours == dateComponents.hour! {
            content.title = "Fagr"
        }else if(hours == dateComponents1.hour!){
            content.title = "Dhukr"
        }else if(hours == dateComponents2.hour!){
            content.title = "Asr"
        }else if(hours == dateComponents3.hour!){
            content.title = "Isha"
        }else if(hours == dateComponents4.hour!){
            content.title = "Magrib"
        }
        
        content.body = "Hurry up to Praying"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: true)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: true)
        let trigger3 = UNCalendarNotificationTrigger(dateMatching: dateComponents3, repeats: true)
        let trigger4 = UNCalendarNotificationTrigger(dateMatching: dateComponents4, repeats: true)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        let request1 = UNNotificationRequest(identifier: "some_long_id1", content: content, trigger: trigger1)
        let request2 = UNNotificationRequest(identifier: "some_long_id2", content: content, trigger: trigger2)
        let request3 = UNNotificationRequest(identifier: "some_long_id3", content: content, trigger: trigger3)
        let request4 = UNNotificationRequest(identifier: "some_long_id4", content: content, trigger: trigger4)
        
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        UNUserNotificationCenter.current().add(request1, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        
        UNUserNotificationCenter.current().add(request3, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        
        UNUserNotificationCenter.current().add(request4, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        removeTransParentView()
        switch indexPath.row {
        case 0:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "upcom") else {fatalError("Unable page")}
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "eventColor")]
            navController.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
            self.present(navController, animated: true)
        case 1:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "Dhikr") else {fatalError("Unable page")}
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        case 2:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "lan") else {fatalError("Unable page")}
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        default:
            print("Errror")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
