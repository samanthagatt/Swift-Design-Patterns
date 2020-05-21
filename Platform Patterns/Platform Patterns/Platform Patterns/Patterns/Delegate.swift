//
//  Delegate.swift
//  Platform Patterns
//
//  Created by Samantha Gatt on 2/3/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

protocol SAMCalendarDelegate {
    /// Lets calendar delegate update their UI when a year has been shown
    mutating func calendar(_ calendar: SAMCalendar, willDisplay year: Int)
    /// Lets calendar delegate take action when a user selects a date
    func calendar(_ calendar: SAMCalendar, didSelect date: Date)
    /// Lets calendar delegate specify if a year should be changeable
    func calendarShouldChangeYear(_ calendar: SAMCalendar) -> Bool
}
protocol SAMCalendarDataSource {
    func calendar(_ calendar: SAMCalendar, eventsFor date: Date) -> [String]
    func calendar(_ calendar: SAMCalendar, add event: String, to date: Date)
}
protocol ReminderPresenting {
    mutating func yearChanged(to year: Int)
}

class SAMCalendar {
    var delegate: SAMCalendarDelegate?
    var dataSource: SAMCalendarDataSource?
    var selectedDate = Date()
    var currentYear: Int = {
        let dateComponents = Calendar.current.dateComponents([.year], from: Date())
        return dateComponents.year ?? 2020
    }()
    
    func changeDate(to date: Date) {
        selectedDate = date
        delegate?.calendar(self, didSelect: date)
        if let items = dataSource?.calendar(self, eventsFor: date),
            items.count > 0 {
            print("Today's events are...")
            items.forEach { print($0) }
        } else {
            print("You have no events today")
        }
    }
    func changeYear(to year: Int) {
        if delegate?.calendarShouldChangeYear(self) ?? true {
            delegate?.calendar(self, willDisplay: year)
            currentYear = year
        }
    }
    func add(event: String) {
        dataSource?.calendar(self, add: event, to: selectedDate)
    }
}

struct Reminders: ReminderPresenting {
    var title: String = {
        let dateComponents = Calendar.current.dateComponents([.year], from: Date())
        return "Year: \(dateComponents.year ?? 2020)"
    }()
    var calendar = SAMCalendar()
    
    init() {
        calendar.delegate = RemindersCalendarDelegate()
        calendar.dataSource = RemindersCalendarDataSource()
    }
    
    mutating func yearChanged(to year: Int) {
        title = "Year: \(year)"
    }
}

struct RemindersCalendarDelegate: SAMCalendarDelegate {
    var parentController: ReminderPresenting?
    func calendarShouldChangeYear(_ calendar: SAMCalendar) -> Bool {
        return true
    }
    mutating func calendar(_ calendar: SAMCalendar, willDisplay year: Int) {
        parentController?.yearChanged(to: year)
    }
    func calendar(_ calendar: SAMCalendar, didSelect date: Date) {
        print("You selected \(date)")
    }
}

struct RemindersCalendarDataSource: SAMCalendarDataSource {
    func calendar(_ calendar: SAMCalendar, eventsFor date: Date) -> [String] {
        return ["Organize sock drawer", "Take over the world"]
    }
    func calendar(_ calendar: SAMCalendar, add event: String, to date: Date) {
        print("You're going to \(event) on \(date).")
    }
}
