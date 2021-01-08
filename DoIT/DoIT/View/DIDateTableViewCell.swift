//
//  DIDateTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/31.
//

import UIKit

class DIDateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var todayButton: UIButton!
    
    func mappingData(_ data: DIItem) {
        startDatePicker.setDate(data.startDate, animated: false)
        endDatePicker.setDate(data.endDate, animated: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
