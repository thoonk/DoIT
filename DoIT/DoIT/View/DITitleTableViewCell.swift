//
//  DITitleTableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2020/12/31.
//

import UIKit

class DITitleTableViewCell: UITableViewCell {

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

extension DITitleTableViewCell: UITextViewDelegate {
    
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

