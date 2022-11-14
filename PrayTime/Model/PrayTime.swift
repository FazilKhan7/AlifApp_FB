//
//  PrayTime.swift
//  PrayTime
//
//  Created by Nurdaulet on 13.11.2022.
//

import Foundation

struct PrayTime {
    let fajr, sunrise, dhuhr, asr, maghrib, isha: String
    
    let weekday: String
    
    let day: String
    let month: String
    var currentDate: String {
        return "\(day) \(month)"
    }
    
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
    }
}
