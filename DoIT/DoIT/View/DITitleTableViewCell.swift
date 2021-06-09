//
//  DITitleTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/31.
//

import UIKit

final class DITitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextView: UITextView!
    
    var titleText: String {
        get {
            return titleTextView.text
        } set {
            titleTextView.text = newValue
            textViewDidChange(titleTextView)
        }
    }

    func mappingData(_ data: DIItem) {
        titleTextView.text = data.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleTextView.delegate = self
        titleTextView.isScrollEnabled = false
        self.selectionStyle = .none
        
        setPlaceHolder(titleTextView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            titleTextView.becomeFirstResponder()
        } else {
            titleTextView.resignFirstResponder()
        }
    }

}
