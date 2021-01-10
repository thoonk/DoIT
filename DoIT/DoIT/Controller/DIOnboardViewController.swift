//
//  DIOnboardViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/07.
//

import UIKit

class DIOnboardViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startedButton: UIButton!
    
    @IBAction func startedBtnTapped(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "check")
        performSegue(withIdentifier: "toMain", sender: self)
        
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension

        startedButton.setTitle("  Get Started  ", for: .normal)
        startedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        startedButton.layer.cornerRadius = 6
    }
}
// MARK: - TableView
extension DIOnboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return C.Onboard.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DIOnboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.onboardCell, for: indexPath) as? DIOnboardTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = C.Onboard.titles[indexPath.row]
        cell.bodyLabel.text = C.Onboard.bodies[indexPath.row]
        cell.exImageView.image = C.Onboard.images[indexPath.row]!

        return cell
    }
}
