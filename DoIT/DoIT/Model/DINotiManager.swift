//
//  DINotiManager.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/29.
//

import Foundation
import UIKit

class DINotiManager {
    
    static let shared = DINotiManager()
    private var notifications = [DINoti]()

    // 알림 권한 요청
    func requestNotiAuth() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: authOptions) { isSuccess, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    // 알림 추가
    func addNoti(_ id: Int, _ title: String, _ body: String, _ date: Date) {
        notifications.append(DINoti(identifier: NSUUID().uuidString, title: title, body: body, date: date, itemId: id))
    }
    // 알림 설정
    func scheduleNoti() {
        for noti in notifications {
            let notiContent = UNMutableNotificationContent()
            notiContent.title = noti.title
            notiContent.body = noti.body
            notiContent.sound = UNNotificationSound.default
            
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: noti.date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(identifier: noti.identifier, content: notiContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Notification Error:", error)
                }
            }
        }
    }
    // 완료되면 알림 삭제
    func removeNoti(with target: Int) {
        var identifiers = [String]()
        for noti in notifications {
            identifiers.append(noti.getNotiForItemId(itemId: target))
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notiRequests) in
            var removeIdentifiers = [String]()
            for noti: UNNotificationRequest in notiRequests {
                for id in identifiers {
                    if noti.identifier == id {
                        removeIdentifiers.append(noti.identifier)
                    }
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
        }
    }
}
