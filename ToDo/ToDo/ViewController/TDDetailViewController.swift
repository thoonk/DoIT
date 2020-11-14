//
//  DetailViewController.swift
//  ToDo
//
//  Created by 김태훈 on 2020/11/10.
//

import UIKit
import RealmSwift

class TDDetailViewController: UIViewController {

    var item: TDItem?
    
    let realm = try? Realm()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!

    @IBAction func completeBtnTapped(_ sender: Any) {
        saveItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if item != nil{
            loadItem()
        }
    }
    
    private func saveItem() {
        if item == nil {
            insertItem()
        } else {
            updateItem()
            
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func loadItem() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        
        if let data = item {
            titleTextField.text = data.title
            descTextView.text = data.descript
            dateLabel.text = "Date: " + dateFormatter.string(from: data.date)
        }
    }
    
    private func insertItem(){
        if let id = incrementID(), let title = titleTextField.text, let desc = descTextView.text{
            item = TDItem(id: id, title: title, descript: desc)
            try! realm?.write{
                realm?.add(item ?? TDItem())
            }
        }
    }
    
    func updateItem() {
        if let title = titleTextField.text, let desc = descTextView.text{
            item = TDItem(id: item!.id, title: title, descript: desc)
            try! realm?.write {
                realm?.add(item ?? TDItem(), update: .modified)
            }
        }
    }
    
    private func incrementID() -> Int?{
        return (realm?.objects(TDItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
