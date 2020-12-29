//
//  TDNotiManager.swift
//  ToDo
//
//  Created by 김태훈 on 2020/12/29.
//

import Foundation
import UIKit

struct TDNotification {
    var id: String
    var title: String
    var body: String
    var date: Date
}

class TDNotiManager {
    
    var notifications = [TDNotification]()
//    let userNotificationCenter = UNUserNotificationCenter.current()

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
    func addNoti(title: String, body: String, date: Date) {
        notifications.append(TDNotification(id: UUID().uuidString, title: title, body: body, date: date))
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
            let request = UNNotificationRequest(identifier: noti.id, content: notiContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Notification Error:", error)
                }
            }
        }
    }
}
