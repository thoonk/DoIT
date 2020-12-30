//
//  TDItemManager.swift
//  ToDo
//
//  Created by 김태훈 on 2020/12/30.
//

import Foundation
import RealmSwift

class TDItemManager: NSObject {
    
    static let shared = TDItemManager()
    
    override init() {
        super.init()
    }
    
    private func getRealm() -> Realm {
        return try! Realm()
    }
    
    func updateComplete(item: TDItem) {
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
    
    func updateEmphasis(item: TDItem) {
        let realm = self.getRealm()
        do {
            if item.isEmphasis == false {
                try realm.write{
                    item.isEmphasis = true
                }
            } else {
                try realm.write{
                    item.isEmphasis = false
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getItems() -> Results<TDItem> {
        let realm = self.getRealm()
        return realm.objects(TDItem.self).sorted(byKeyPath: "id", ascending: true)
    }
    
    func insertItem(titleTextView: UITextView, descTextView: UITextView, startDate: Date, endDate: Date){
        let realm = self.getRealm()
        
        var item: TDItem
        
        do {
            if let id = incrementID(),
               let title = titleTextView.text,
               let desc = descTextView.text {
                item = TDItem(id: id, title: title, descript: desc, startDate: startDate, endDate: endDate)
                try realm.write{
                    realm.add(item)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(item: TDItem?, titleTextView: UITextView, descTextView: UITextView, startDate: Date, endDate: Date) {
        
        let realm = self.getRealm()
        do {
            if let title = titleTextView.text,
               let desc = descTextView.text,
               var item = item {
                item = TDItem(id: item.id, title: title, descript: desc, startDate: startDate, endDate: endDate)
                try realm.write {
                    realm.add(item, update: .modified)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(item: TDItem) {
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
        return (realm.objects(TDItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
