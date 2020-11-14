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
    
    convenience init (id: Int, title: String, descript: String) {
        self.init()
        self.id = id
        self.title = title
        self.descript = descript
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
//    let id: Int
//    let title: String?
//    let description: String?
//    let date: String?
//
//    init(id: Int, title: String?, description: String?, date: String?) {
//        self.id = id
//        self.title = title
//        self.description = description
//        self.date = date
//    }
}

