//
//  DIOnboardViewController.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/07.
//

import UIKit

class DIOnboardViewController: UIViewController {
    
    let images: [UIImage?] = [
        UIImage(named: "mark"),
        UIImage(named: "delete"),
        UIImage(named: "complete"),
        UIImage(named: "selectOption"),
        UIImage(named: "resultLess"),
        UIImage(named: "darkmode")
    ]

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startedButton: UIButton!
    
    @IBAction func startedBtnTapped(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "check")
        performSegue(withIdentifier: "toMain", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        startedButton.setTitle("  Get Started  ", for: .normal)
        startedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        startedButton.layer.cornerRadius = 6
    }
}

extension DIOnboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return C.Onboard.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DIOnboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: C.CellIdentifier.onboardCell, for: indexPath) as? DIOnboardTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = C.Onboard.titles[indexPath.row]
        cell.bodyLabel.text = C.Onboard.bodies[indexPath.row]
        cell.exImageView.image = images[indexPath.row]!

        return cell
    }
}
