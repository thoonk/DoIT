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

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func writeBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: C.detailFromTable, sender: nil)
    }
    
    @IBAction func completeBtnPressed(_ sender: UIButton) {
        
        let contentView = sender.superview?.superview?.superview
        let cell: TDTableViewCell = contentView?.superview as! TDTableViewCell
        let indexPath = tableView.indexPath(for: cell)!

        TDItemManager.shared.updateComplete(item: (items?[indexPath.row])!)
        
        if let item = items?[indexPath.row] {
            if item.isComplete == false {
                sender.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            } else {
                sender.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        items = TDItemManager.shared.getItems()
        
//        let titleLabel = UILabel()
//        titleLabel.textColor = UIColor.label
//        titleLabel.text = "Do IT"
//        titleLabel.font = UIFont.systemFont(ofSize: 25.0)
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "BackgroundColor")
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if self.items != nil {
            return self.items!.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TDTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.tableCell, for: indexPath) as? TDTableViewCell else {
            return UITableViewCell()
        }
        if let data = self.items?[indexPath.row] {
            cell.mappingData(data)
            cell.cellView.layer.cornerRadius = 7
            cell.cellView.layer.masksToBounds = true
            
            if data.isEmphasis == false {
                cell.markImageView.isHidden = true
            } else {
                cell.markImageView.isHidden = false
            }
            
            if data.isComplete == true {
                cell.completeButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            } else {
                cell.completeButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
        
        return cell
    }
    
    /// tableViewCell 오른쪽에서 왼쪽으로 스와이프해서 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        // 할 일 삭제
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (contextualAction, view, isSuccess) in
            TDItemManager.shared.deleteItem(item: (self.items?[indexPath.row])!)
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        deleteAction.image = UIImage(systemName: "delete.left")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    /// tableViewCell 왼쪽에서 오른쪽으로 스와이프해서 하이라이트
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 강조 / 강조 취소
        let emphasisAction = UIContextualAction(style: .normal, title: "") { (contextualAction, view, isSuccess) in
            
            TDItemManager.shared.updateEmphasis(item: (self.items?[indexPath.row])!)
            
            if let cell: TDTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.tableCell, for: indexPath) as? TDTableViewCell {
                
                if let item = self.items?[indexPath.row] {
                
                    if item.isEmphasis == false {
                        cell.markImageView.isHidden = true
                    } else {
                        cell.markImageView.isHidden = false
                    }
                }
            }
            tableView.reloadData()
        }
        
        emphasisAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        emphasisAction.image = UIImage(systemName: "star.fill")

        
        let swipeActions = UISwipeActionsConfiguration(actions: [emphasisAction])
        return swipeActions
    }
    
    // 선택된 cell의 정보로 DetailVC로 화면 전환
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items?[indexPath.row]
//        let index = indexPath
        performSegue(withIdentifier: C.detailFromTable, sender: item)
    }
}

