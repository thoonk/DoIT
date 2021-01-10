//
//  Date.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/27.
//

import Foundation

extension Date {
    
    func alertTime () -> Date {
        if let reminderValue: Int = UserDefaults.standard.value(forKey: "reminderTime") as? Int {
            return Calendar.current.date(byAdding: .minute, value: -reminderValue, to: self)!
        } else {
            return Calendar.current.date(byAdding: .minute, value: -10, to: self)!
        }
    }
}

