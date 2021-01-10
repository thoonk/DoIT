//
//  DIDescTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/02.
//

import UIKit

class DIDescTableViewCell: UITableViewCell {

    @IBOutlet weak var descTextView: UITextView!
    
    var descText: String {
        get {
            return descTextView.text
        } set {
            descTextView.text = newValue
            textViewDidChange(descTextView)
        }
    }
    
    func mappingData(_ data: DIItem) {
        descTextView.text = data.descript
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        descTextView.delegate = self
        descTextView.isScrollEnabled = false
        self.selectionStyle = .none

        setPlaceHolder(descTextView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            descTextView.becomeFirstResponder()
        } else {
            descTextView.resignFirstResponder()
        }
    }
}

