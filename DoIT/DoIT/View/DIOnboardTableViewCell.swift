//
//  DIOnboardTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/07.
//

import UIKit

final class DIOnboardTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var exImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}
