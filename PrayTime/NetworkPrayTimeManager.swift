//
//  NetworkPrayTimeManager.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import Foundation
import CoreLocation
//protocol PrayerTimeDelegate: class {
//    func updateInterface(_: NetworkPrayTimeManager, with prayerTime: PrayTime)
//}

class NetworkPrayTimeManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
//    weak var delegate: PrayerTimeDelegate?
    var onCompletion: ((PrayTime) -> Void)?
    
    
    func fetchCurrentPrayTime(forRequestTime requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.aladhan.com/v1/timingsByCity?city=\(city)&country=Kazakhstan&method=2&apikey=\(apiKey)"
            break
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.aladhan.com/v1/timings?latitude=\(latitude)&longitude=\(longitude)&method=2&day=13&month=11&year=2022&apikey=\(apiKey)"
            break
        }
        performRequest(withUrlString: urlString)
    }
    
//    func fetchCurrentPrayTime(forCity city: String) {
//        let urlString = "https://api.aladhan.com/v1/timingsByCity?city=\(city)&country=Kazakhstan&method=2&apikey=\(apiKey)"
//        performRequest(withUrlString: urlString)
//    }
//
//
//    func fetchCurrentPrayTime(forLatitude: CLLocationDegrees, forLongitude: CLLocationManager) {
//        let urlString = "https://api.aladhan.com/v1/timings?latitude=\(forLatitude)&longitude=\(forLongitude)&method=2&day=13&month=11&year=2022&apikey=\(apiKey)"
//    }
    
    fileprivate func performRequest(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentPrayTime = self.parseJSON(withdata: data) {
//                    self.delegate?.updateInterface(self, with: currentPrayTime)
                    self.onCompletion?(currentPrayTime)
                }
                
            }
        }
        
        task.resume()
    }
    
    
    fileprivate func parseJSON(withdata data: Data) -> PrayTime? {
        let decoder = JSONDecoder()
        
        do {
            let currentPrayTimeData = try decoder.decode(CurrentPrayTimeData.self, from: data)
            guard let prayTime = PrayTime(currentPrayTime: currentPrayTimeData) else { return nil }
            return prayTime
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
