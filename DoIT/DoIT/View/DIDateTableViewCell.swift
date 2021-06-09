//
//  DIDateTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/31.
//

import UIKit

final class DIDateTableViewCell: UITableViewCell {
    
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
        startDatePicker.locale = Locale(identifier: "en")
        endDatePicker.locale = Locale(identifier: "en")
        todayButton.setImage(UIImage(systemName: "calendar"), for: .normal)
    }
}
