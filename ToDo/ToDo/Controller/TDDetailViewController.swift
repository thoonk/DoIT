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
    
    let currentDate: Date = Date()
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    let notiManager = TDNotiManager()
    
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
        
        if startDate > endDate {
            endDatePicker.date = startDate
            endDate = startDate
            alertOutOfDate("End Date must be set later than the Start Date")
        } else {
            saveItem()
            if let item = self.item {
                notiManager.addNoti(title: item.title, body: C.notiBody.startBody, date: item.startDate.alertTime())
                notiManager.addNoti(title: item.title, body: C.notiBody.endBody, date: item.endDate.alertTime())
                notiManager.scheduleNoti()
            }
            navigationController?.popViewController(animated: true)
        }
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
            computeDate()
        }
        
        viewUI(view: infoView)
        viewUI(view: dateView)
        viewUI(view: resultView)
        
        titleTextView.backgroundColor = UIColor.darkGray
        descTextView.backgroundColor = UIColor.darkGray
        resultTextView.backgroundColor = UIColor.darkGray
        
        if let item = self.item, item.isComplete == true {
            titleTextView.isUserInteractionEnabled = false
            descTextView.isUserInteractionEnabled = false
            startDatePicker.isUserInteractionEnabled = false
            endDatePicker.isUserInteractionEnabled = false
        }
        
        notiManager.requestNotiAuth()
    }
    
    // 할 일을 완료하면 날짜 계산해서 보여줌
    func computeDate() {
        let calendar = Calendar.current
        
        if let item = self.item, item.isComplete == true, item.startDate != item.endDate {
            if item.endDate > item.completeDate! {
                let time = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: item.completeDate!, to: item.endDate)
                
                if case let (year?, month?, day?, hour?, minute?, second?) = (time.year,time.month,time.day,time.hour,time.minute,time.second) {
                    
                    self.resultTextView.text = "Year: \(year) Month: \(month) Day: \(day)\n Hour: \(hour) Minute: \(minute) Second: \(second)"
                }
            } else {
                let time = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: item.endDate, to: item.completeDate!)
                
                if case let (year?, month?, day?, hour?, minute?, second?) = (time.year,time.month,time.day,time.hour,time.minute,time.second) {
                    self.resultTextView.text = "\(year)년, \(month)월, \(day)일, \(hour)시, \(minute)분, \(second)초"
                }
            }
        }
    }
    
    /// 종료날짜보다 시작날짜가 더 늦을 경우 알림 메서드
    func alertOutOfDate(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    func viewUI(view: UIView) {
        //        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.backgroundColor = UIColor.darkGray.cgColor
    }
    
    func saveItem() {
        if item == nil {
            TDItemManager.shared.insertItem(titleTextView: titleTextView, descTextView: descTextView, startDate: startDate, endDate: endDate)
        } else {
            TDItemManager.shared.updateItem(item: item, titleTextView: titleTextView, descTextView: descTextView, startDate: startDate, endDate: endDate)
        }
    }
    
    func loadItem() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        
        if let data = item {
            titleTextView.text = data.title
            descTextView.text = data.descript
            dateLabel.text = dateFormatter.string(from: data.date)
            startDatePicker.setDate(data.startDate, animated: false)
            endDatePicker.setDate(data.endDate, animated: false)
        }
    }
}

