//
//  DIItem.swift
//  DoIT
//
//  Created by 김태훈 on 2020/11/10.
//

import Foundation
import RealmSwift

class DIItem: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var descript = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var completeDate: Date?
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var isMark: Bool = false
    @objc dynamic var isSwitchOn: Bool = false
    
    convenience init (id: Int, title: String, descript: String, startDate: Date, endDate: Date, isSwitchOn: Bool) {
        self.init()
        self.id = id
        self.title = title
        self.descript = descript
        self.startDate = startDate
        self.endDate = endDate
        self.isSwitchOn = isSwitchOn
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

