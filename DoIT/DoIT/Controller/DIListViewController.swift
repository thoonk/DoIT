//
//  DIListViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2020/11/10.
//  

import UIKit
import RealmSwift

class DIListViewController: UIViewController {
    // MARK: - Properties
    var items: Results<DIItem>?
    let notiManager = DINotiManager()

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    @IBAction func writeBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: C.SegueIdentifier.detailFromTable, sender: nil)
    }

    @IBAction func completeBtnPressed(_ sender: UIButton) {
        
        let contentView = sender.superview?.superview?.superview
        let cell: DIListViewCell = contentView?.superview as! DIListViewCell
        let indexPath = tableView.indexPath(for: cell)!

        if let item = items?[indexPath.row] {
            if item.isComplete == false {
                sender.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                cell.titleLabel.attributedText = cell.titleLabel.text?.strikeThrough()
                DINotiManager.shared.removeNoti(with: item.id)
            } else {
                sender.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
        
        DIItemManager.shared.updateComplete(with: (items?[indexPath.row])!)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "BackgroundColor")
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notiManager.requestNotiAuth()
        items = DIItemManager.shared.getItems()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.SegueIdentifier.detailFromTable {
            if let vc = segue.destination as? DIDetailViewController, let item = sender as? DIItem {
                vc.item = item
            }
        }
    }
}

// MARK: - TableView
extension DIListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DIListViewCell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.tableCell, for: indexPath) as? DIListViewCell else {
            return UITableViewCell()
        }
        if let data = self.items?[indexPath.row] {
            cell.mappingData(data)
            cell.cellView.layer.cornerRadius = 10
            cell.cellView.layer.masksToBounds = true
            
            if data.isMark == false {
                cell.markImageView.isHidden = true
            } else {
                cell.markImageView.isHidden = false
            }
            
            if data.isComplete == true {
                cell.completeButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                cell.titleLabel.attributedText = cell.titleLabel.text?.strikeThrough()
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
            DIItemManager.shared.deleteItem(with: (self.items?[indexPath.row])!)
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        
        let deleteIcon = UIImage(systemName: "delete.left")?.withTintColor(UIColor(named: "ImageColor")!, renderingMode: .alwaysOriginal)
        
        deleteAction.image = deleteIcon
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    /// tableViewCell 왼쪽에서 오른쪽으로 스와이프해서 하이라이트
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 강조 / 강조 취소
        let markAction = UIContextualAction(style: .normal, title: "") { (contextualAction, view, isSuccess) in
            
            DIItemManager.shared.updateMark(with: (self.items?[indexPath.row])!)
            if let cell: DIListViewCell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.tableCell, for: indexPath) as? DIListViewCell {
                
                if let item = self.items?[indexPath.row] {
                
                    if item.isMark == false {
                        cell.markImageView.isHidden = true
                    } else {
                        cell.markImageView.isHidden = false
                    }
                }
            }
            tableView.reloadData()
        }
        
        markAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)

        let markIcon = UIImage(systemName: "star.fill")?.withTintColor(UIColor(named: "ImageColor")!, renderingMode: .alwaysOriginal)
        
        markAction.image = markIcon
    
        let swipeActions = UISwipeActionsConfiguration(actions: [markAction])
        return swipeActions
    }
    
    // 선택된 cell의 정보로 DetailVC로 화면 전환
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = self.items?[indexPath.row] {
            performSegue(withIdentifier: C.SegueIdentifier.detailFromTable, sender: item)
        }
    }
}
