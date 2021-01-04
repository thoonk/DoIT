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

extension DIDescTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: .infinity))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let indexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    /// placeHolder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == C.TextPlaceHolder.text {
            textView.text = ""
            textView.textColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor.white
                default:
                    return UIColor.black
                }
            }
        } else {
            textView.textColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor.white
                default:
                    return UIColor.black
                }
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = C.TextPlaceHolder.text
            textView.textColor = UIColor.placeholderText
        }
    }
    
    func setPlaceHolder(_ textView: UITextView) {
        if textView.text == C.TextPlaceHolder.text {
            textView.textColor = UIColor.placeholderText
        } else {
            textView.textColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor.white
                default:
                    return UIColor.black
                }
            }
        }
    }
}
