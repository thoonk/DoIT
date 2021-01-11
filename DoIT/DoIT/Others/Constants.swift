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
        static let resultTextInit = "퍼포먼스를 설정하고 항목을 완료하면 결과를 확인할 수 있습니다!!"
        static let resultTextLess = "만큼 종료 날짜보다 더 빨리 일을 끝냈습니다. 축하드립니다!!"
        static let resultTextMore = "만큼 종료 날짜보다 더 늦게 일을 끝냈습니다. 힘내세요!!"
        static let resultTextNil = "시작과 종료시간이 동일하여 결과가 없습니다."
    }
    
    struct TextPlaceHolder {
        static let text = "여기에 작성해주세요!"
    }
    
    struct DetailSection {
        static let title = 0
        static let desc = 1
        static let date = 2
        static let result = 3
    }
    
    struct InfoSection {
        static let setting = 0
        static let about = 1
    }

    struct CellIdentifier {
        static let tableCell: String = "tableCell"
        static let titleCell: String = "titleCell"
        static let descCell: String = "descCell"
        static let dateCell: String = "dateCell"
        static let resultCell: String = "resultCell"
        static let onboardCell: String = "onboardCell"
        static let settingCell: String = "settingCell"
        static let infoCell: String = "infoCell"
    }
    
    struct SegueIdentifier {
        static let mainFromOnboard: String = "mainFromOnboard"
        static let detailFromTable: String = "detailFromTable"
        static let onboardFromInfo: String = "onboardFromInfo"
    }
    
    struct Info {
        static let infos: [String] = ["유저 가이드", "앱 버전", "리뷰", "피드백"]
    }
    
    struct Reminder {
        static let hour: Int = 60
        static let halfHour: Int = 30
        static let tenMin : Int = 10
        static let setTime: Int = 0

        static let options: Dictionary<Int,String> = [
            60:"1시간 전",
            30:"30분 전",
            10:"10분 전",
            0: "설정한 시간"
        ]
    }
    
    struct UserDefaultsKey {
        static let time: String = "reminderTime"
        static let check: String = "checkUsingFirst"
    }
    
    struct Onboard {
        static let titles: [String] = ["마크:", "삭제:", "완료:", "퍼포먼스:", "결과:", "다크모드:"]
        static let bodies: [String] = [
            "왼쪽에서 오른쪽으로 항목을 밀고 항목에 마크를 하세요!!",
            "오른쪽에서 왼쪽으로 항목을 밀고 항목을 지우세요!!",
            "동그라미 버튼을 누르고, 항목을 완료하세요!! 완료하면 알림은 자동으로 삭제됩니다. \n동그라미 버튼을 다시 누르면 완료가 취소됩니다.",
            "시작과 종료 시간을 설정하고, 설정된 시간에 알림을 받으세요!! \n시작 시간만 설정하고, 저장 버튼을 눌러보세요. 그리고 옵션을 선택하세요!!",
            "시작과 종료 시간을 설정하고 항목을 완료하세요. 그러면 결과를 확인할 수 있습니다!!",
            "DoIT의 라이트와 다크모드를 보고싶다면 기기의 화면 스타일을 변경해보세요!"
        ]
        
        static let images: [UIImage?] = [
            UIImage(named: "mark"),
            UIImage(named: "delete"),
            UIImage(named: "complete"),
            UIImage(named: "selectOption"),
            UIImage(named: "resultLess"),
            UIImage(named: "darkmode")
        ]
    }
    
    struct StoryboardID {
        static let onboardVC = "onboardVC"
    }
}
