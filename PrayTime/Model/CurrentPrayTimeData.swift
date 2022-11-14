//
//  CurrentPrayTime.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import Foundation

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
