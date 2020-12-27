//
//  ViewController.swift
//  Todo
//
//  Created by 김태훈 on 2020/11/10.
//  

import UIKit
import RealmSwift

class TDTableViewController: UIViewController {
    
    var items: Results<TDItem>?
    let realm = try? Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func writeBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: C.detailFromTable, sender: nil)
    }
    
    @IBAction func folderBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        items = realm?.objects(TDItem.self).sorted(byKeyPath: "id", ascending: true)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Do IT"
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.detailFromTable {
            if let vc = segue.destination as? TDDetailViewController, let item = sender as? TDItem {
                vc.item = item
            }
        }
    }
}

// MARK: - TableView
extension TDTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = items?.count{
            return cnt
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TDTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.tableCell, for: indexPath) as? TDTableViewCell else {
            return UITableViewCell()
        }
        if let data = items?[indexPath.row]{
            cell.mappingData(data)
            
            if data.isEmphasis == false {
                cell.markImageView.isHidden = true
            } else {
                cell.markImageView.isHidden = false
            }
            
            if data.isComplete == true {
                cell.titleLabel.attributedText = cell.titleLabel.text?.strikeThrough()
            } else {
                cell.titleLabel.text = data.title
            }
        }
        return cell
    }
    
    /// tableViewCell 오른쪽에서 왼쪽으로 스와이프해서 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 완료 / 미완료
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (contextualAction, view, isSuccess) in
            do {
                
                if let item = self.items?[indexPath.row] {
                    if item.isComplete == false {
                        
                        try self.realm?.write{
                            item.isComplete = true
                            item.completeDate = Date()
                        }
                        
                        if let cell: TDTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.tableCell, for: indexPath) as? TDTableViewCell {
                            cell.titleLabel.attributedText = cell.titleLabel.text?.strikeThrough()
                            self.tableView.reloadData()
                        }
                    } else {
                        
                        try self.realm?.write {
                            item.isComplete = false
                            item.completeDate = nil
                        }
                        
                        if let cell: TDTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.tableCell, for: indexPath) as? TDTableViewCell {
                            cell.mappingData(item)
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        
        // 할 일 삭제
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, isSuccess) in
            do {
                try self.realm?.write{
                    self.realm?.delete(self.items![indexPath.row])
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        
        completeAction.backgroundColor = .blue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
        return swipeActions
    }
    
    /// tableViewCell 왼쪽에서 오른쪽으로 스와이프해서 하이라이트
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 강조 / 강조 취소
        let emphasisAction = UIContextualAction(style: .normal, title: "Emphasis") { (contextualAction, view, isSuccess) in
            
            do{
                if let cell: TDTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.tableCell, for: indexPath) as? TDTableViewCell {
                    
                    let item = self.items?[indexPath.row]
                    
                    if item?.isEmphasis == false {
                        try self.realm?.write{
                            item?.isEmphasis = true
                            self.tableView.reloadData()
                        }
                        cell.markImageView.isHidden = true
                    } else {
                        try self.realm?.write{
                            item?.isEmphasis = false
                            self.tableView.reloadData()
                        }
                        cell.markImageView.isHidden = false
                    }
                }
            } catch {
                print(error)
            }
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [emphasisAction])
        return swipeActions
    }
    
    // 선택된 cell의 정보로 DetailVC로 화면 전환
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items?[indexPath.row]
        performSegue(withIdentifier: C.detailFromTable, sender: item)
        
    }
}

