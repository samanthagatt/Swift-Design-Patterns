//
//  Delegate.swift
//  Platform Patterns
//
//  Created by Samantha Gatt on 2/3/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

class SAMCalendar {
    weak var delegate: SAMCalendarDelegate?
    var selectedDate = Date()
    var currentYear: Int = {
        let dateComponents = Calendar.current.dateComponents([.year], from: Date())
        return dateComponents.year ?? 2020
    }()
    
    func changeDate(to date: Date) {
        selectedDate = date
        delegate?.calendar(self, didSelect: date)
    }
    func changeYear(to year: Int) {
        if delegate?.calendarShouldChangeYear(self) ?? true {
            delegate?.calendar(self, willDisplay: year)
            currentYear = year
        }
    }
}

protocol SAMCalendarDelegate: class {
    /// Lets calendar delegate update their UI when a year has been shown
    func calendar(_ calendar: SAMCalendar, willDisplay year: Int)
    /// Lets calendar delegate take action when a user selects a date
    func calendar(_ calendar: SAMCalendar, didSelect date: Date)
    /// Lets calendar delegate specify if a year should be changeable
    func calendarShouldChangeYear(_ calendar: SAMCalendar) -> Bool
}

class Reminders: SAMCalendarDelegate {
    var title: String = {
        let dateComponents = Calendar.current.dateComponents([.year], from: Date())
        return "Year: \(dateComponents.year ?? 2020)"
    }()
    var calendar = SAMCalendar()
    
    init() {
        calendar.delegate = self
    }
    
    func calendarShouldChangeYear(_ calendar: SAMCalendar) -> Bool {
        return true
    }
    func calendar(_ calendar: SAMCalendar, willDisplay year: Int) {
        title = "Year: \(year)"
    }
    func calendar(_ calendar: SAMCalendar, didSelect date: Date) {
        print("You selected \(date)")
    }
}
