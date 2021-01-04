//
//  DINoti.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/03.
//

import Foundation
import RealmSwift

struct DINoti {
    var identifier = ""
    var title = ""
    var body = ""
    var date = Date()
    var itemId = 0
    
    func getNotiForItemId(itemId: Int) -> String {
        if self.itemId == itemId {
            return identifier
        }
        return "none"
    }
}
