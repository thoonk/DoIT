//
//  DIDetailViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2020/11/10.
//

import UIKit
import RealmSwift

final class DIDetailViewController: UIViewController {
    
    // MARK: - Properties
    var item: DIItem?
    let currentDate: Date = Date()
    var startDate: Date = Date()
    var endDate: Date = Date()
    let time = UserDefaults.standard.value(
        forKey: C.UserDefaultsKey.time
    ) as? Int ?? 10
    /// 퍼포먼스 스위치 플래그
    var switchFlag = false {
        didSet {
            let indexPathForDate = NSIndexPath(
                row: 0,
                section: C.DetailSection.date
            ) as IndexPath
            tableView.reloadRows(at: [indexPathForDate], with: .fade)
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var completeImageView: UIImageView!
    
    // MARK: - IBAction
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        
        if let item = self.item {
            DIItemManager.shared.deleteItem(with: item)
            navigationController?.popViewController(animated: true)
        }
    }
    
    /**
     저장하는 버튼 눌렀을 때 실행되는 메서드
     
     시작 날짜 > 종료 날짜
     - 시작 시간에만 알림을 받을지, 시작과 종료 시간에 알림받을지 선택하는 메서드 호출
     
     시작 날짜 < 종료 날짜
     - 시작과 끝 시간 알림 처리 메서드 호출
     
     시작 날짜 == 종료 날짜
     - 시작시간 알림 처리 메서드
     */
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        var newItem: DIItem = DIItem()
        
        let indexPathForDate = NSIndexPath(
            row: 0,
            section: C.DetailSection.date
        ) as IndexPath
        let dateCell = tableView.cellForRow(
            at: indexPathForDate
        ) as? DIDateTableViewCell
        
        if self.item != nil {
            startDate = dateCell?.startDatePicker.date ?? Date()
            endDate = dateCell?.endDatePicker.date ?? Date()
        }
        if startDate > endDate {
            selectPerformanceOrNoti()
        } else if startDate < endDate {
            newItem = saveItem()
            setNotifyTwice(newItem)
            navigationController?.popViewController(animated: true)
        } else {
            newItem = saveItem()
            setNotifyOnce(newItem)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        startDate = sender.date
    }
    
    @IBAction func endDateChanged(_ sender: UIDatePicker) {
        endDate = sender.date
    }
  
    /// 현재 날짜로 설정하는 메서드
    @IBAction func todayBtnTapped(_ sender: UIButton) {
        let indexPathForDate = NSIndexPath(
            row: 0,
            section: C.DetailSection.date
        ) as IndexPath
        let dateCell = tableView.cellForRow(
            at: indexPathForDate
        ) as? DIDateTableViewCell
        
        dateCell?.startDatePicker.setDate(Date(), animated: true)
        dateCell?.endDatePicker.setDate(Date(), animated: true)
    }
    
    @IBAction func doneBtnTapped(sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            switchFlag = true
        } else {
            switchFlag = false
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setDateLabelText()
        setDetailUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UserDefinedFunction
    /// 알림 메서드
    func alertToUser(_ title: String, _ message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let okAction = UIAlertAction(title: "확인", style: .default) 
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// alert action에 따라 알림 설정하는 메서드
    func selectPerformanceOrNoti() {
        let alert = UIAlertController(
            title: "알림",
            message: "종료 날짜는 시작 날짜 이후로 설정해야 합니다.",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        
        let indexPathForDate = NSIndexPath(
            row: 0,
            section: C.DetailSection.date
        ) as IndexPath
        let dateCell = tableView.cellForRow(
            at: indexPathForDate
        ) as? DIDateTableViewCell
        
        let onlyNotiAction = UIAlertAction(
            title: "시작 시간에만 알림",
            style: .default
        ) { action in
            dateCell?.endDatePicker.setDate(self.startDate, animated: false)
            self.endDate = self.startDate
            let newItem = self.saveItem()
            self.setNotifyOnce(newItem)
            self.navigationController?.popViewController(animated: true)
        }
        
        let setPerformAction = UIAlertAction(
            title: "시작과 종료 시간 모두 알림",
            style: .default
        ) { action in
            dateCell?.endDatePicker.setDate(self.startDate, animated: false)
            self.endDate = self.startDate
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(onlyNotiAction)
        alert.addAction(setPerformAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// 시작시간 알림 처리 메서드
    func setNotifyOnce(_ newItem: DIItem) {
        if let item = self.item {
            DINotiManager.shared.removeNoti(with: item.id)
            DINotiManager.shared.addNoti(
                item.id, item.title,
                "시작까지 \(time)분 남았습니다!!",
                item.startDate.alertTime()
            )
            DINotiManager.shared.scheduleNoti()
        } else {
            DINotiManager.shared.addNoti(
                newItem.id, newItem.title,
                "시작까지 \(time)분 남았습니다!!",
                newItem.startDate.alertTime()
            )
            DINotiManager.shared.scheduleNoti()
        }
    }
    
    /// 시작과 끝 시간 알림 처리 메서드
    func setNotifyTwice(_ newItem: DIItem) {
        if let item = self.item {
            DINotiManager.shared.removeNoti(with: item.id)
            DINotiManager.shared.addNoti(
                item.id,
                item.title,
                "시작까지 \(time)분 남았습니다!!",
                item.startDate.alertTime()
            )
            DINotiManager.shared.addNoti(
                item.id, item.title,
                "종료까지 \(time)분 남았습니다!!",
                item.endDate.alertTime()
            )
            DINotiManager.shared.scheduleNoti()
        } else {
            DINotiManager.shared.addNoti(
                newItem.id, newItem.title,
                "시작까지 \(time)분 남았습니다!!",
                newItem.startDate.alertTime()
            )
            DINotiManager.shared.addNoti(
                newItem.id, newItem.title,
                "종료까지 \(time)분 남았습니다!!",
                newItem.endDate.alertTime()
            )
            DINotiManager.shared.scheduleNoti()
        }
    }
    
    /// Item 저장 메서드
    func saveItem() -> DIItem {
        var newItem: DIItem = DIItem()
        
        let indexPathForTitle = NSIndexPath(
            row: 0,
            section: C.DetailSection.title
        ) as IndexPath
        let indexPathForDesc = NSIndexPath(
            row: 0,
            section: C.DetailSection.desc
        ) as IndexPath
        let indexPathForDate = NSIndexPath(
            row: 0,
            section: C.DetailSection.date
        ) as IndexPath

        let titleCell = tableView.cellForRow(
            at: indexPathForTitle
        ) as? DITitleTableViewCell
        let descCell = tableView.cellForRow(
            at: indexPathForDesc
        ) as? DIDescTableViewCell
        let dateCell = tableView.cellForRow(
            at: indexPathForDate
        ) as? DIDateTableViewCell
        
        let titleText = titleCell!.titleTextView.text ?? ""
        let descText = descCell!.descTextView.text ?? ""
        let setStartDate = dateCell?.startDatePicker.date
        let setEndDate = dateCell?.endDatePicker.date
        
        if !titleText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty,
           titleText != C.TextPlaceHolder.text {
            if self.item == nil {
                newItem = DIItemManager.shared.insertItem(
                    titleText,
                    descText,
                    startDate,
                    endDate,
                    switchFlag
                )
            } else {
                if self.item?.startDate == setStartDate
                    || self.item?.endDate == setEndDate {
                    newItem = DIItemManager.shared.updateItem(
                        item,
                        titleText,
                        descText,
                        setStartDate ?? Date(),
                        setEndDate ?? Date(),
                        switchFlag
                    )
                } else {
                    newItem = DIItemManager.shared.updateItem(
                        item,
                        titleText,
                        descText,
                        startDate,
                        endDate,
                        switchFlag
                    )
                }
            }
        } else {
            alertToUser("알림", "제목을 입력해주세요!")
        }
        return newItem
    }
    
    /// DateLabel의 텍스트 설정
    func setDateLabelText() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en")
        
        if let item = item {
            dateLabel.text = dateFormatter.string(from: item.date)
        } else {
            dateLabel.text = dateFormatter.string(from: Date())
        }
    }
    
    /// TableView 설정
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    /// DetailViewUI 설정
    func setDetailUI() {
        if let item = item {
            switchFlag = item.isSwitchOn
            deleteButton.isEnabled = true
            deleteButton.title = "삭제"
            
            if item.isComplete == false {
                completeImageView.isHidden = true
            }
        } else {
            switchFlag = false
            deleteButton.isEnabled = false
            deleteButton.title = ""
            completeImageView.isHidden = true
        }
    }
    
    /// 키보드 완료 버튼 설정
    func setKeyboardDoneBtn() -> UIToolbar {
        let bar = UIToolbar()
        let leftSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneBtn = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneBtnTapped)
        )
        bar.items = [leftSpace, doneBtn]
        bar.sizeToFit()
        return bar
    }
}

// MARK: - TableView
extension DIDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
 
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        switch indexPath.section {
        // 할일 제목에 해당하는 cell
        case C.DetailSection.title:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: C.CellIdentifier.titleCell,
                    for: indexPath
            ) as? DITitleTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                cell.setPlaceHolder(cell.titleTextView)
                if item.isComplete == true {
                    cell.titleTextView.isEditable = false
                }
            }
            
            let bar = setKeyboardDoneBtn()
            cell.titleTextView.inputAccessoryView = bar
            
            return cell
        // 메모에 해당하는 cell
        case C.DetailSection.desc:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: C.CellIdentifier.descCell,
                    for: indexPath
            ) as? DIDescTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                cell.setPlaceHolder(cell.descTextView)
                if item.isComplete == true {
                    cell.descTextView.isEditable = false
                }
            }
            
            let bar = setKeyboardDoneBtn()
            cell.descTextView.inputAccessoryView = bar
            
            return cell
        // 퍼포먼스 설정에 해당하는 cell
        case C.DetailSection.date:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: C.CellIdentifier.dateCell,
                    for: indexPath
            ) as? DIDateTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
                if item.isComplete == true {
                    cell.startDatePicker.isUserInteractionEnabled = false
                    cell.endDatePicker.isUserInteractionEnabled = false
                    cell.todayButton.isUserInteractionEnabled = false
                }
            }
            cell.todayButton.setImage(UIImage(systemName: "calendar"), for: .normal)
            return cell
        // 퍼포먼스 결과에 해당하는 cell
        case C.DetailSection.result:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: C.CellIdentifier.resultCell,
                    for: indexPath
            ) as? DIResultTableViewCell else { return UITableViewCell() }
            
            if let item = item {
                cell.mappingData(item)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
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
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        if section == C.DetailSection.date {
            let header = UIView(
                frame: CGRect(x: 20, y: 0, width: 250, height: 30)
            )
            header.isUserInteractionEnabled = true
            
            let label = UILabel(
                frame: CGRect(x: 20, y: 0, width: 100, height: 25)
            )
            label.text = "퍼포먼스:"
            label.lineBreakMode = .byTruncatingTail
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 20)
            header.addSubview(label)
            
            let dateSwitch = UISwitch(
                frame: CGRect(x: 120, y: 0, width: 80, height: 30)
            )
            dateSwitch.isEnabled = true
            dateSwitch.isUserInteractionEnabled = true
            dateSwitch.setOn(item?.isSwitchOn ?? false, animated: false)
            dateSwitch.onTintColor = UIColor(named: "ViewColor")
            dateSwitch.addTarget(
                self,
                action: #selector(switchChanged(_:)),
                for: UIControl.Event.valueChanged
            )
            
            if let item = item {
                if item.isComplete == true {
                    dateSwitch.isEnabled = false
                } else {
                    dateSwitch.isEnabled = true
                }
            }
            
            header.addSubview(dateSwitch)
            
            return header
        } else {
            return nil
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        if section == C.DetailSection.date {
            return 30
        } else {
            return 0
        }
    }
}

