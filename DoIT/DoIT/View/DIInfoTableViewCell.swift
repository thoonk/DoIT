//
//  DIInfoTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/06.
//

import UIKit

class DIInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
