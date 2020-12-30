//
//  Date.swift
//  ToDo
//
//  Created by 김태훈 on 2020/12/27.
//

import Foundation

extension Date {
        
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
            return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func alertTime () -> Date {
        return Calendar.current.date(byAdding: .minute, value: -10, to: self)!
    }
}

