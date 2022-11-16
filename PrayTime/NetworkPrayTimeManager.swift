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
        case cityCountryName(city: String, country: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
        case qiblaDirection(latitude: Double, longitude: Double)
        case currentCityName(latitude: Double, longitude: Double)
    }
    
    enum APItype {
        case cityCountryName
        case coordinate
        case qibla
        case currentCity
    }
    
    
//    weak var delegate: PrayerTimeDelegate?
    var onCompletion: ((PrayTime) -> Void)?
    var onCompletion2: ((CurrentCity) -> Void)?
    var onCompletion3: ((CurrentQiblaDirection) -> Void)?
    
    
    func fetchCurrentPrayTime(forRequestTime requestType: RequestType){
        var urlString = ""
        var type: APItype

        switch requestType {
        case .cityCountryName(let country, let city):
            urlString = "https://api.aladhan.com/v1/timingsByCity?city=\(city)&country=\(country)&method=2&apikey=\(apiKey)"
            type = .cityCountryName
            break
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.aladhan.com/v1/timings?latitude=\(latitude)&longitude=\(longitude)&method=2&day=13&month=11&year=2022&apikey=\(apiKey)&apikey=\(apiKey)"
            type = .coordinate
            break
        case .qiblaDirection(latitude: let latitude, longitude: let longitude):
            urlString = "https://api.aladhan.com/v1/qibla/\(latitude)/\(longitude)&apikey=\(apiKey)"
            type = .qibla
            break
        case .currentCityName(let latitude, let longitude):
            urlString = "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=\(latitude)&longitude=\(longitude)&localityLanguage=en"
            type = .currentCity
            break
            
        }
        
        performRequest(withUrlString: urlString, type: type)
    }

    
    fileprivate func performRequest(withUrlString urlString: String, type: APItype) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                
                switch type {
                case .cityCountryName:
                    if let currentData = self.parseJSON1(withdata: data){
                        self.onCompletion?(currentData)
                    } else {
                        print("ERRRRRROOOOOOOORRRR2")
                    }
                    break
                case .coordinate:
                    if let currentData = self.parseJSON1(withdata: data){
                        self.onCompletion?(currentData)
                    } else {
                        print("ERRRRRROOOOOOOORRRR2")
                    }
                    break
                case .currentCity:
                    if let currentData = self.parseJSON2(withdata: data){
                        self.onCompletion2?(currentData)
                    } else {
                        print("ERRRRRROOOOOOOORRRR1")
                    }
                    break
                case .qibla:
                    if let currentData = self.parseJSON3(withdata: data){
                        self.onCompletion3?(currentData)
                    } else {
                        print("ERRRRRROOOOOOOORRRR3")
                    }
                    break
                }
                
            }
        }
        
        task.resume()
    }
    
    
    fileprivate func parseJSON1(withdata data: Data) -> PrayTime? {
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
    
    fileprivate func parseJSON2(withdata data: Data) -> CurrentCity? {
        let decoder = JSONDecoder()
        
        do {
            let currentCityData = try decoder.decode(CurrentCityData.self, from: data)
            guard let cityData = CurrentCity(currentCityData: currentCityData) else { return nil }
            return cityData
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    fileprivate func parseJSON3(withdata data: Data) -> CurrentQiblaDirection? {
        let decoder = JSONDecoder()
        
        do {
            let currentQiblaData = try decoder.decode(QiblaDirectionData.self, from: data)
            guard let qiblaData = CurrentQiblaDirection(qiblaDirection: currentQiblaData) else { return nil }
            return qiblaData
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
}
