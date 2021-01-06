//
//  DIInfoViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/05.
//

import UIKit

class DIInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DIInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return C.Info.infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DIInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? DIInfoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.infoLabel.text = C.Info.infos[indexPath.row]
        cell.descLabel.text = C.Info.detail[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "About DoIT"
        default:
            return ""
        }
    }
}
