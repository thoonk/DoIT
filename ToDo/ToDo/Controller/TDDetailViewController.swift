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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBAction func completeBtnTapped(_ sender: Any) {
        
        if startDate > endDate {
            let indexPathForDate = NSIndexPath(row: 0, section: C.DetailSection.date) as IndexPath
            let dateCell = tableView.cellForRow(at: indexPathForDate) as? DateTableViewCell
            dateCell?.endDatePicker.setDate(startDate, animated: false)
            endDate = startDate
            alertToUser("End Date must be set later than the Start Date", "")
        } else {
            saveItem()
            if let item = self.item {
                notiManager.addNoti(title: item.title, body: C.NotiBody.startBody, date: item.startDate.alertTime())
                notiManager.addNoti(title: item.title, body: C.NotiBody.endBody, date: item.endDate.alertTime())
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        if let item = item {
            dateLabel.text = dateFormatter.string(from: item.date)
        } else {
            dateLabel.text = dateFormatter.string(from: Date())
        }
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /// 알림 메서드
    func alertToUser(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    func saveItem() {
        
        let indexPathForTitle = NSIndexPath(row: 0, section: C.DetailSection.title) as IndexPath
        let indexPathForDesc = NSIndexPath(row: 0, section: C.DetailSection.desc) as IndexPath
        let titleCell = tableView.cellForRow(at: indexPathForTitle) as? TitleTableViewCell
        let descCell = tableView.cellForRow(at: indexPathForDesc) as? DescTableViewCell
        let titleText = titleCell!.titleTextView.text ?? ""
        let descText = descCell!.descTextView.text ?? ""
        
        if titleText != "", descText != "" {
            if titleText != "Write here" {
                if item == nil {
                    TDItemManager.shared.insertItem(titleText: titleText, descText: descText, startDate: startDate, endDate: endDate)
                } else {
                    TDItemManager.shared.updateItem(item: item, titleText: titleText, descText: descText, startDate: startDate, endDate: endDate)
                }
            } else {
                alertToUser("Alert", "Write the title please")
            }
        } else {
            print("TitleText is Nil")
        }
    }
}

extension TDDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
            
        case C.DetailSection.title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.titleCell, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                if item.isComplete == true {
                    cell.titleTextView.isUserInteractionEnabled = false
                }
            }
            return cell
        
        case C.DetailSection.desc:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.descCell, for: indexPath) as? DescTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                if item.isComplete == true {
                    cell.descTextView.isUserInteractionEnabled = false
                }
            }
            return cell
            
        case C.DetailSection.date:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.dateCell, for: indexPath) as? DateTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                if item.isComplete == true {
                    cell.startDatePicker.isUserInteractionEnabled = false
                    cell.endDatePicker.isUserInteractionEnabled = false
                }
            }
            return cell
            
        case C.DetailSection.result:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.resultCell, for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == C.DetailSection.date {
            return 200
        } else if indexPath.section == C.DetailSection.result {
            return 200
        } else {
            return UITableView.automaticDimension
        }
    }
}

