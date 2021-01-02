//
//  ResultTableViewCell.swift
//  ToDo
//
//  Created by 김태훈 on 2020/12/31.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var resultTextView: UITextView!
    
    func mappingData(_ data: TDItem) {
        let time = computeDate(data)
        if case let (year?, month?, day?, hour?, minute?, second?) = (time.year,time.month,time.day,time.hour,time.minute,time.second) {
            
            resultTextView.text = "Year: \(year) Month: \(month) Day: \(day)\n Hour: \(hour) Minute: \(minute) Second: \(second)"
        }
    }
    
    // 할 일을 완료하면 날짜 계산해서 보여줌
    func computeDate(_ data: TDItem?) -> DateComponents {
        if let data = data, data.isComplete == true, data.startDate != data.endDate {
            let calendar = Calendar.current
            
            if data.endDate > data.completeDate! {
                let time = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: data.completeDate!, to: data.endDate)
                return time
            } else {
                let time = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: data.endDate, to: data.completeDate!)
                return time
            }
        }
        return DateComponents.init()
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
