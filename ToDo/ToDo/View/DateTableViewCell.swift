//
//  DateTableViewCell.swift
//  ToDo
//
//  Created by 김태훈 on 2020/12/31.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!

    func mappingData(_ data: TDItem) {
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
