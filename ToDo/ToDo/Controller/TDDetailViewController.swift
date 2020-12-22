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
    
    var startDate: Date = Date()
    var endDate: Date = Date()
        
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var resultView: UIView!
    
    @IBAction func completeBtnTapped(_ sender: Any) {
        saveItem()
    }
    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        startDate = sender.date
    }
    @IBAction func endDateChanged(_ sender: UIDatePicker) {
        endDate = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if item != nil{
            loadItem()
        }
        
        textViewUI(view: infoView)
        textViewUI(view: dateView)
        textViewUI(view: resultView)
    }
    
    func textViewUI(view: UIView) {
//        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.backgroundColor = UIColor.darkGray.cgColor
    }
    
    func saveItem() {
        if item == nil {
            insertItem()
        } else {
            updateItem()
        }
        navigationController?.popViewController(animated: true)
    }
    
    func loadItem() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        
        if let data = item {
            titleTextView.text = data.title
            descTextView.text = data.descript
            dateLabel.text = "Register Date: " + dateFormatter.string(from: data.date)
            startDatePicker.setDate(data.startDate!, animated: false)
            endDatePicker.setDate(data.endDate!, animated: false)
        }
    }
    
    func insertItem(){
        if let id = incrementID(),
           let title = titleTextView.text,
           let desc = descTextView.text {
            item = TDItem(id: id, title: title, descript: desc, startDate: startDate, endDate: endDate)
            try! realm?.write{
                realm?.add(item ?? TDItem())
            }
        }
    }
    
    func updateItem() {
        if let title = titleTextView.text,
           let desc = descTextView.text {
            item = TDItem(id: item!.id, title: title, descript: desc, startDate: startDate, endDate: endDate)
            try! realm?.write {
                realm?.add(item ?? TDItem(), update: .modified)
            }
        }
    }
    
    func incrementID() -> Int?{
        return (realm?.objects(TDItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

