//
//  DIInfoTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/06.
//

import UIKit

final class DIInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}
