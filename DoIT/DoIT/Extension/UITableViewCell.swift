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

