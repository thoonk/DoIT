//
//  ToDoItem.swift
//  ToDo
//
//  Created by 김태훈 on 2020/11/10.
//

import Foundation
import RealmSwift

class TDItem: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var descript = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var startDate: Date?
    @objc dynamic var endDate: Date?
    
    convenience init (id: Int, title: String, descript: String, startDate: Date, endDate: Date) {
        self.init()
        self.id = id
        self.title = title
        self.descript = descript
        self.startDate = startDate
        self.endDate = endDate
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

