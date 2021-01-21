//
//  DIItemManager.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/30.
//

import Foundation
import RealmSwift

class DIItemManager: NSObject {
    
    static let shared = DIItemManager()
    
    override init() {
        super.init()
    }
    
    private func getRealm() -> Realm {
        return try! Realm()
    }
    
    func updateComplete(with item: DIItem) {
        let realm = self.getRealm()
        do {
            if item.isComplete == false {
                try realm.write{
                    item.isComplete = true
                    item.completeDate = Date()
                }
            } else {
                try realm.write {
                    item.isComplete = false
                    item.completeDate = nil
                }
            }
        } catch {
            print(error)
        }
    }
    
    func updateMark(with item: DIItem) {
        let realm = self.getRealm()
        do {
            if item.isMark == false {
                try realm.write{
                    item.isMark = true
                }
            } else {
                try realm.write{
                    item.isMark = false
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getItems() -> Results<DIItem> {
        let realm = self.getRealm()
        return realm.objects(DIItem.self).sorted(byKeyPath: "id", ascending: true)
    }
    
    func insertItem(_ titleText: String, _ descText: String, _ startDate: Date, _ endDate: Date, _ isSwitchOn: Bool) -> DIItem {
        let realm = self.getRealm()
        var item: DIItem = DIItem()
        do {
            if let id = incrementID() {
                item = DIItem(id: id, title: titleText, descript: descText, startDate: startDate, endDate: endDate, isSwitchOn: isSwitchOn, isMark: false)
                try realm.write{
                    realm.add(item)
                }
            }
        } catch {
            print(error)
        }
        return item
    }
    
    func updateItem(_ item: DIItem?, _ titleText: String, _ descText: String, _ startDate: Date, _ endDate: Date, _ isSwitchOn: Bool) -> DIItem {
        let realm = self.getRealm()
        do {
            if var item = item {
                item = DIItem(id: item.id, title: titleText, descript: descText, startDate: startDate, endDate: endDate, isSwitchOn: isSwitchOn, isMark: item.isMark)
                try realm.write {
                    realm.add(item, update: .modified)
                }
            }
        } catch {
            print(error)
        }
        return item ?? DIItem()
    }
    
    func deleteItem(with item: DIItem) {
        DINotiManager.shared.removeNoti(with: item.id)
        let realm = self.getRealm()
        do {
            try realm.write{
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    func incrementID() -> Int?{
        let realm = self.getRealm()
        return (realm.objects(DIItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
