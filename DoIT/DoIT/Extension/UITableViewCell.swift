//
//  UITableViewCell.swift
//  DoIT
//
//  Created by 김태훈 on 2021/01/06.
//

import Foundation
import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
}

extension UITableViewCell: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
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
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == C.TextPlaceHolder.text {
            textView.text = ""
        }
        textView.textColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
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

