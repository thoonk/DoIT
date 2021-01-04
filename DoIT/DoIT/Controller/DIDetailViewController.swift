//
//  DIDetailViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2020/11/10.
//

import UIKit
import RealmSwift

class DIDetailViewController: UIViewController {
    
    var item: DIItem?
    
    let currentDate: Date = Date()
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    var switchFlag = false {
        didSet {
            let indexPathForDate = NSIndexPath(row: 0, section: C.DetailSection.date) as IndexPath
            tableView.reloadRows(at: [indexPathForDate], with: .fade)
        }
    }
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @objc func switchChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            switchFlag = true
        } else {
            switchFlag = false
        }
    }
    
    @IBAction func completeBtnTapped(_ sender: UIButton) {
        var newItem: DIItem = DIItem()
                
        if startDate > endDate {
            let indexPathForDate = NSIndexPath(row: 0, section: C.DetailSection.date) as IndexPath
            let dateCell = tableView.cellForRow(at: indexPathForDate) as? DIDateTableViewCell
            dateCell?.endDatePicker.setDate(startDate, animated: false)
            endDate = startDate
            alertToUser("Alert", "End Date must be set later than the Start Date")
        } else if startDate < endDate {
            newItem = saveItem()
            if let item = self.item {
                DINotiManager.shared.addNoti(item.id, item.title, C.NotiBody.startBody, item.startDate.alertTime())
                DINotiManager.shared.addNoti(item.id, item.title, C.NotiBody.endBody, item.endDate.alertTime())
                DINotiManager.shared.scheduleNoti()
            } else {
                DINotiManager.shared.addNoti(newItem.id, newItem.title, C.NotiBody.startBody, newItem.startDate.alertTime())
                DINotiManager.shared.addNoti(newItem.id, newItem.title, C.NotiBody.endBody, newItem.endDate.alertTime())
                DINotiManager.shared.scheduleNoti()
            }
            navigationController?.popViewController(animated: true)
            
        } else {
            newItem = saveItem()
            if let item = self.item {
                DINotiManager.shared.addNoti(item.id, item.title, C.NotiBody.nowBody, item.startDate)
                DINotiManager.shared.scheduleNoti()
            } else {
                DINotiManager.shared.addNoti(newItem.id, newItem.title, C.NotiBody.nowBody, newItem.startDate)
                DINotiManager.shared.scheduleNoti()
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
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        if let item = item {
            dateLabel.text = dateFormatter.string(from: item.date)
            switchFlag = item.isSwitchOn
        } else {
            dateLabel.text = dateFormatter.string(from: Date())
            switchFlag = false
        }
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
    
    func saveItem() -> DIItem {
        var newItem: DIItem = DIItem()
        let indexPathForTitle = NSIndexPath(row: 0, section: C.DetailSection.title) as IndexPath
        let indexPathForDesc = NSIndexPath(row: 0, section: C.DetailSection.desc) as IndexPath
        let titleCell = tableView.cellForRow(at: indexPathForTitle) as? DITitleTableViewCell
        let descCell = tableView.cellForRow(at: indexPathForDesc) as? DIDescTableViewCell
        let titleText = titleCell!.titleTextView.text ?? ""
        let descText = descCell!.descTextView.text ?? ""
        
        if titleText != "", descText != "" {
            if titleText != "Write here" {
                if self.item == nil {
                    newItem = DIItemManager.shared.insertItem(titleText, descText, startDate, endDate, switchFlag)
                } else {
                    newItem = DIItemManager.shared.updateItem(item, titleText, descText, startDate, endDate, switchFlag)
                }
            } else {
                alertToUser("Alert", "Write the title please")
            }
        } else {
            print("TitleText is Nil")
        }
        return newItem
    }
}

extension DIDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case C.DetailSection.title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.titleCell, for: indexPath) as? DITitleTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                if item.isComplete == true {
                    cell.titleTextView.isUserInteractionEnabled = false
                }
            }
            return cell
        
        case C.DetailSection.desc:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.descCell, for: indexPath) as? DIDescTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                if item.isComplete == true {
                    cell.descTextView.isUserInteractionEnabled = false
                }
            }
            return cell
            
        case C.DetailSection.date:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.dateCell, for: indexPath) as? DIDateTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                if item.isComplete == true {
                    cell.startDatePicker.isUserInteractionEnabled = false
                    cell.endDatePicker.isUserInteractionEnabled = false
                }
            }
            return cell
            
        case C.DetailSection.result:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.resultCell, for: indexPath) as? DIResultTableViewCell else { return UITableViewCell() }
            
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
            if switchFlag == false {
                return 0
            } else {
                return 200
            }
        } else if indexPath.section == C.DetailSection.result {
            return 180
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == C.DetailSection.date {
            let header = UIView(frame: CGRect(x: 15, y: 0, width: 250, height: 50))
            header.isUserInteractionEnabled = true
            
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: 120, height: 25))
            label.text = "Performance"
            label.lineBreakMode = .byTruncatingTail
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20)
            header.addSubview(label)
            
            let dateSwitch = UISwitch(frame: CGRect(x: 150, y: 0, width: 80, height: 50))
            dateSwitch.isEnabled = true
            dateSwitch.isUserInteractionEnabled = true
            dateSwitch.setOn(item?.isSwitchOn ?? false, animated: false)
            dateSwitch.onTintColor = UIColor(named: "ViewColor")
            dateSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: UIControl.Event.valueChanged)
            
            header.addSubview(dateSwitch)
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == C.DetailSection.date {
            return 50
        } else {
            return 0
        }
    }
}

