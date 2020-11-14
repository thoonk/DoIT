//
//  ViewController.swift
//  Todo
//
//  Created by 김태훈 on 2020/11/10.
//

import UIKit
import RealmSwift

class TDTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: Results<TDItem>?
    
    let realm = try? Realm()
    
    let cellIdentifier: String = "tableCell"
    let segueIdentifier: String = "toDetailFromTable"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func writeMemo(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        items = realm?.objects(TDItem.self).sorted(byKeyPath: "id", ascending: true)
        self.tableView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "목록"
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    // MARK: - tableView
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
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TDTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TDTableViewCell else {
            return UITableViewCell()
        }
        if let data = items?[indexPath.row]{
            cell.mappingData(data)
        }
        return cell
    }
    /// tableViewCell 스와이프해서 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "삭제") { (contextualAction, view, boolValue) in
            do {
                try self.realm?.write{
                    self.realm?.delete(self.items![indexPath.row])
                    self.tableView.reloadData()
                }
            } catch {
                print("\(error)")
            }
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    // 선택된 cell의 정보로 DetailVC로 화면 전환
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items?[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: item)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let vc = segue.destination as? TDDetailViewController, let item = sender as? TDItem {
                vc.item = item
            }
        }
    }
    
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
}
