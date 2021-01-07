//
//  DIResultTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/31.
//

import UIKit

class DIResultTableViewCell: UITableViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var monView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourView: UIView!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var minView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    func mappingData(_ data: DIItem) {
        let time = computeDate(data)
        if case let (year?, month?, day?, hour?, minute?) = (time.year,time.month,time.day,time.hour,time.minute) {
            
            yearLabel.text = "\(year)"
            monLabel.text = "\(month)"
            dayLabel.text = "\(day)"
            hourLabel.text = "\(hour)"
            minLabel.text = "\(minute)"
        }
    }
    
    /// 할 일을 완료하면 날짜 계산해서 보여줌
    func computeDate(_ data: DIItem?) -> DateComponents {
        if let data = data, data.isComplete == true {
            if data.startDate != data.endDate {
                let calendar = Calendar.current
                
                if data.endDate > data.completeDate! {
                    let time = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: data.completeDate!, to: data.endDate)
                    resultLabel.text = C.Result.resultTextLess
                    return time
                } else {
                    let time = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: data.endDate, to: data.completeDate!)
                    resultLabel.text = C.Result.resultTextMore
                    return time
                }
            } else {
                resultLabel.text = C.Result.resultTextNil
            }
        }
        return DateComponents.init()
    }
    
    /// 뷰의 쉐도우 효과 설정
    func viewsUI(_ views: [UIView]) {
        
        for view in views {
            view.layer.shadowOffset = .zero
            view.layer.shadowOpacity = 0.3
            view.layer.shadowRadius = 10
            view.layer.shadowColor = UIColor(named: "ImageColor")?.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        resultLabel.text = C.Result.resultTextInit
        viewsUI([yearView,monView,dayView,hourView,minView])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
