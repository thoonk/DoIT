//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by 김태훈 on 2020/11/10.
//

import UIKit

class TDTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    func mappingData(_ data: TDItem){
        titleLabel.text = data.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}
