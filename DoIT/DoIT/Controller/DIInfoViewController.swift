//
//  DIInfoViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/05.
//

import UIKit

class DIInfoViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // 비어 있는 row의 라인 제거
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - UserDefinedFunction
    /// 알림 시간 선택할 수 있는 함수
    func setReminderTime() {
        
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let titleAttrString = NSMutableAttributedString(string: "Set Reminder Time", attributes: titleFont)
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let messageAttrString = NSMutableAttributedString(string: "Choose the time you want to be notified", attributes: messageFont)
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
        
        let hourAction = UIAlertAction(title: C.Reminder.options[60], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.hour, forKey: "reminderTime")
            self.tableView.reloadData()
        }
        let halfHourAction = UIAlertAction(title: C.Reminder.options[30], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.halfHour, forKey: "reminderTime")
            self.tableView.reloadData()
        }
        let tenMinAction = UIAlertAction(title: C.Reminder.options[10], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.tenMin, forKey: "reminderTime")
            self.tableView.reloadData()
        }
        let setTimeAction = UIAlertAction(title: C.Reminder.options[0], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.setTime, forKey: "reminderTime")
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        actionSheet.addAction(setTimeAction)
        actionSheet.addAction(tenMinAction)
        actionSheet.addAction(halfHourAction)
        actionSheet.addAction(hourAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
}
// MARK: - TableView
extension DIInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == C.InfoSection.setting {
            return 1
        } else if section == C.InfoSection.about {
            return C.Info.infos.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case C.InfoSection.setting:
            guard let cell: DISettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.settingCell, for: indexPath) as? DISettingTableViewCell else { return UITableViewCell() }
            
            cell.reminderLabel.text = "Reminder Time"
            if let time: Int = UserDefaults.standard.value(forKey: "reminderTime") as? Int {
                cell.setTimeLabel.text = C.Reminder.options[time]
            } else {
                cell.setTimeLabel.text = C.Reminder.options[10]
            }
            
            return cell
            
        case C.InfoSection.about:
            guard let cell: DIInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.infoCell, for: indexPath) as? DIInfoTableViewCell else { return UITableViewCell() }
            
            cell.infoLabel.text = C.Info.infos[indexPath.row]
            cell.descLabel.text = C.Info.detail[indexPath.row]
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Settings"
        case 1:
            return "About DoIT"
        default:
            return ""
        }
    }
    /// 섹션헤더 배경색 바꾸는 함수
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor(named: "ViewColor")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == C.InfoSection.setting {
            if indexPath.row == 0 {
                setReminderTime()
                tableView.reloadData()
            }
        }
        else if indexPath.section == C.InfoSection.about ,indexPath.row == 0 {
            performSegue(withIdentifier: C.SegueIdentifier.onboardFromInfo, sender: nil)
        }
    }
}
