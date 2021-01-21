//
//  DIInfoViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/05.
//

import UIKit
import StoreKit

class DIInfoViewController: UIViewController {
    // MARK: - Properties
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        return "\(version)"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // 비어 있는 row의 라인 제거
        tableView.tableFooterView = UIView(frame: .zero)
        
        closeButton.setTitle("닫기", for: .normal)
        closeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        if isReviewToBeDisplayed(10) == true {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    // MARK: - UserDefinedFunction
    /// 알림 시간 선택할 수 있는 함수
    func setReminderTime() {
        
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let titleAttrString = NSMutableAttributedString(string: "알림 시간 설정", attributes: titleFont)
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let messageAttrString = NSMutableAttributedString(string: "알림을 받고 싶은 시간을 선택하세요!", attributes: messageFont)
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
        
        let hourAction = UIAlertAction(title: C.Reminder.options[60], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.hour, forKey: C.UserDefaultsKey.time)
            self.tableView.reloadData()
        }
        let halfHourAction = UIAlertAction(title: C.Reminder.options[30], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.halfHour, forKey: C.UserDefaultsKey.time)
            self.tableView.reloadData()
        }
        let tenMinAction = UIAlertAction(title: C.Reminder.options[10], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.tenMin, forKey: C.UserDefaultsKey.time)
            self.tableView.reloadData()
        }
        let setTimeAction = UIAlertAction(title: C.Reminder.options[0], style: .default) { (action) in
            UserDefaults.standard.set(C.Reminder.setTime, forKey: C.UserDefaultsKey.time)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
        }
        
        actionSheet.addAction(setTimeAction)
        actionSheet.addAction(tenMinAction)
        actionSheet.addAction(halfHourAction)
        actionSheet.addAction(hourAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func isReviewToBeDisplayed(_ minCount: Int) -> Bool {
        let launchCount = UserDefaults.standard.integer(forKey: C.UserDefaultsKey.review)
        
        if launchCount == minCount {
            UserDefaults.standard.set(0, forKey: C.UserDefaultsKey.review)
            return true
        } else {
            UserDefaults.standard.set(launchCount+1, forKey: C.UserDefaultsKey.review)
            return false
        }
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
            
            cell.reminderLabel.text = "알림 시간"
            if let time: Int = UserDefaults.standard.value(forKey: C.UserDefaultsKey.time) as? Int {
                cell.setTimeLabel.text = C.Reminder.options[time]
            } else {
                cell.setTimeLabel.text = C.Reminder.options[10]
            }
            
            return cell
            
        case C.InfoSection.about:
            guard let cell: DIInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.infoCell, for: indexPath) as? DIInfoTableViewCell else { return UITableViewCell() }
            
            cell.infoLabel.text = C.Info.infos[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.descLabel.text = ""
            case 1:
                cell.descLabel.text = version
            default:
                cell.descLabel.text = "추가될 예정입니다:)"
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "설정"
        case 1:
            return "DoIT에 대해"
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
