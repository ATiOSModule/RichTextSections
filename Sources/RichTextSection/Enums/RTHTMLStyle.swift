//
//  RTHTMLStyle.swift
//  RichTextSection
//
//  Created by Anh Tuấn Nguyễn on 5/3/26.
//

import Foundation
import UIKit

public enum RTHTMLStyle {
    case font(UIFont)
    case size(Int)
    case color(String)
    
    var htmlTag: String {
        switch self {
        case .font(let font):
            return "font-family: '\(font.familyName)'"
        case .size(let size):
            return "font-size: \(size)px"
        case .color(let hexColor):
            return "color: \(hexColor)"
        }
    }
}
