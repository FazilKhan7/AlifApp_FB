//
//  PrayTime.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import Foundation

//MARK: - Pray time data

struct CurrentPrayTimeData : Codable {
    let code: Int
    let status: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let timings: Timings
    let date: DateClass
    let meta: Meta
}

// MARK: - DateClass
struct DateClass: Codable {
    let readable, timestamp: String
    let gregorian: Gregorian
}

// MARK: - Gregorian
struct Gregorian: Codable {
    let date, format, day: String
    let weekday: Weekday
    let month: Month
}

// MARK: - Month
struct Month: Codable {
    let number: Int
    let en: String
}

// MARK: - Weekday
struct Weekday: Codable {
    let en: String
}

// MARK: - Meta
struct Meta: Codable {
    let latitude, longitude: Double
    let timezone: String
}

// MARK: - Timings
struct Timings: Codable {
    let fajr, sunrise, dhuhr, asr: String
    let maghrib, isha: String
    
    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case sunrise = "Sunrise"
        case dhuhr = "Dhuhr"
        case asr = "Asr"
        case maghrib = "Maghrib"
        case isha = "Isha"
    }
}

struct PrayTime {
    let fajr, sunrise, dhuhr, asr, maghrib, isha: String
    
    let weekday: String
    
    let day: String
    let month: String
    var currentDate: String {
        return "\(day) \(month)"
    }
    
    let longitude: Double
    let latitude: Double
    
    init?(currentPrayTime: CurrentPrayTimeData) {
        fajr = currentPrayTime.data.timings.fajr
        sunrise = currentPrayTime.data.timings.sunrise
        dhuhr = currentPrayTime.data.timings.dhuhr
        asr = currentPrayTime.data.timings.asr
        maghrib = currentPrayTime.data.timings.maghrib
        isha = currentPrayTime.data.timings.isha
        
        weekday = currentPrayTime.data.date.gregorian.weekday.en
        day = currentPrayTime.data.date.gregorian.day
        month = currentPrayTime.data.date.gregorian.month.en
        
        longitude = currentPrayTime.data.meta.longitude
        latitude = currentPrayTime.data.meta.latitude
    }
}

//MARK: - City Data

struct CurrentCityData: Codable {
    let latitude, longitude: Double
    let city, countryName: String
}

struct CurrentCity {
    let city: String
    let counrty: String
    
    init?(currentCityData: CurrentCityData) {
        city = currentCityData.city
        counrty = currentCityData.countryName
    }
}


//MARK: - Qibla direction data

struct QiblaDirectionData: Codable {
    let data: DataClassOfQibla
}

// MARK: - DataClass
struct DataClassOfQibla: Codable {
    let latitude, longitude, direction: Double
}

struct CurrentQiblaDirection {
    let direction: Double
    
    init?(qiblaDirection: QiblaDirectionData) {
        direction = qiblaDirection.data.direction
    }
}
