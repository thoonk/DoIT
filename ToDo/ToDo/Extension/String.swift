//
//  String.swift
//  ToDo
//
//  Created by 김태훈 on 2020/12/27.
//

import Foundation
import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
            let attributeString =  NSMutableAttributedString(string: self)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
            return attributeString
    }
}
