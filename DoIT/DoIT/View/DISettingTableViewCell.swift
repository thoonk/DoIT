//
//  DISettingTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/08.
//

import UIKit

class DISettingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var setTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
