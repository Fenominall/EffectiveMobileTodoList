//
//  ConvertingExtensions.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

func convertDate(with date: Date?) -> String {
    guard let validDate = date else {
        return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: validDate)
}

func convertDateForShort(with date: Date) -> String {
    let calendar = Calendar.current
    if calendar.isDateInToday(date) {
        return "Today"
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM"
        return dateFormatter.string(from: date)
    }
}

func convertDateToString(date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateFormat = "EEEE, d MMMM" // EEEE for full weekday name, d for day, MMMM for full month name
  return formatter.string(from: date)
}

