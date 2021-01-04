//
//  Constants.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/24.
//

import Foundation

struct C {
    
    struct TextPlaceHolder {
        static let text = "Write here"
    }
    
    struct NotiBody {
        static let startBody: String = "Start Time left 10min !!"
        static let endBody: String = "End Time left 10min !!"
        static let nowBody: String = "Do IT Now !!"
    }
    
    struct DetailSection {
        static let title = 0
        static let desc = 1
        static let date = 2
        static let result = 3
    }
    
    struct CellIdentifier {
        static let tableCell: String = "tableCell"
        static let titleCell: String = "titleCell"
        static let descCell: String = "descCell"
        static let dateCell: String = "dateCell"
        static let resultCell: String = "resultCell"
    }
    
    struct SegueIdentifier {
        static let detailFromTable: String = "detailFromTable"
    }
}
