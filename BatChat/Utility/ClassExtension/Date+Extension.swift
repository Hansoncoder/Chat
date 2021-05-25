//
//  Date+Extension.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/5.
//  Copyright © 2018 Hanson. All rights reserved.
//

import Foundation

extension Date {

    static func getCurrentText(format: String) -> String {
        return Date().getText(format: format)
    }

    static func getCurrentWeakDay() -> String {
        return getWeakDay(for: Date())
    }



    static func getWeakDay(for date: Date) -> String {

        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday, .hour]
        let components = calendar.components(unitFlags, from: date)
        guard let weekday = components.weekday else {
            return ""
        }
        switch weekday {
        case 1:
            return "星期天"
        case 2:
            return "星期一"
        case 3:
            return "星期二"
        case 4:
            return "星期三"
        case 5:
            return "星期四"
        case 6:
            return "星期五"
        case 7:
            return "星期六"
        default:
            return ""
        }
    }

    static func getText(from date: Date, format: String) -> String {
        return date.getText(format: format)
    }

    public func getText(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func getDate(from date: String, format: String = "yyyy/MM/dd HH:mm:ss")
        -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }
    
    public func toSting() -> String {
        self.getText(format: "yyyy-MM-dd")
    }
    
    var year: Int {
        return components(date: self).year!
    }
    var month: Int {
        return components(date: self).month!
    }
    var day: Int {
        return components(date: self).day!
    }
    var hour: Int {
        return components(date: self).hour!
    }
    var minute: Int {
        return components(date: self).minute!
    }
    var second: Int {
        return components(date: self).second!
    }
    func components(date: Date) -> DateComponents {
        let calendar = Calendar.current
        let componentsSet = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let components = calendar.dateComponents(componentsSet, from: date)
        return components
    }

    var daysInYear: Int {
        return (self.isLeapYear ? 366 : 365)
    }

    var isLeapYear: Bool {
        let year = self.year
        return (year%4==0 ? (year%100==0 ? (year%400==0 ? true : false) : true) : false)
    }

    /// 当前时间的月份的第一天是周几
    var firstWeekDayInThisMonth: Int {
        var calendar = Calendar.current
        let componentsSet = Set<Calendar.Component>([.year, .month, .day])
        var components = calendar.dateComponents(componentsSet, from: self)

        calendar.firstWeekday = 1
        components.day = 1
        let first = calendar.date(from: components)
        let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: first!)
        return firstWeekDay! - 1
    }
    /// 当前时间的月份共有多少天
    var totalDaysInThisMonth: Int {
        let totalDays = Calendar.current.range(of: .day, in: .month, for: self)
        return (totalDays?.count)!
    }

    /// 上个月份的此刻日期时间
    var lastMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let newData = Calendar.current.date(byAdding: dateComponents, to: self)
        return newData!
    }
    /// 下个月份的此刻日期时间
    var nextMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let newData = Calendar.current.date(byAdding: dateComponents, to: self)
        return newData!
    }

    /// 格式化时间
    ///
    /// - Parameters:
    ///   - formatter: 格式 yyyy-MM-dd/YYYY-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss
    /// - Returns: 格式化后的时间 String
    func formatterDate(formatter: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        let dateString = dateformatter.string(from: self)
        return dateString
    }

}

extension String {
    public func toDate(_ format: String = "yyyy/MM/dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}

