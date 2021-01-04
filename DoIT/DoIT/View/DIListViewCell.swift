//
//  DIListViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2020/11/10.
//

import UIKit

class DIListViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    func mappingData(_ data: DIItem){
        titleLabel.text = data.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}
