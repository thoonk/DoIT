//
//  Constants.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/24.
//

import Foundation
import UIKit

struct C {
    
    struct Result {
        static let resultTextInit = "Set performance and tap complete button. And then check the result!!"
        
        static let resultTextLess = "Less than the endDate"
        static let resultTextMore = "More than the endDate"
        static let resultTextNil = "No results, this is because the start time and end time are the same."
    }
    
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
    
    struct InfoSection {
        static let about = 0
    }
    
    struct CellIdentifier {
        static let tableCell: String = "tableCell"
        static let titleCell: String = "titleCell"
        static let descCell: String = "descCell"
        static let dateCell: String = "dateCell"
        static let resultCell: String = "resultCell"
        static let onboardCell: String = "onboardCell"
    }
    
    struct SegueIdentifier {
        static let toMain: String = "toMain"
        static let detailFromTable: String = "detailFromTable"
        static let onboardFromInfo: String = "onboardFromInfo"
    }
    
    struct Info {
        static let infos: [String] = ["User Guide", "App Version", "Review", "Feedback"]
        static let detail: [String] = ["", "1.0", "Please:)", "Please:)"]
    }
    
    struct Onboard {
        static let titles: [String] = ["Mark", "Delete", "Complete", "Performance", "Result", "DarkMode"]
        static let bodies: [String] = [
            "Swipe an item from left to right and mark the item!!",
            "Swipe an item from right to left and delete the item!!",
            "Tap the round button, and complete it!! And notifications are auto deleted.\nTap again to cancel the complete.",
            "Set the start time and end time, notifications will arrive at each set time!!\nSet only the start time, and click the save button. And choose the options!!",
            "Set the start and end times and tap the complete button. And check the result!!",
            "Change the appearance of your device to see DoIT's light/dark mode"
        ]
    }
    struct StoryboardID {
        static let onboardVC = "onboardVC"
    }
}
