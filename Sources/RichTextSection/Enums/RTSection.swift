//
//  File.swift
//  RichTextSection
//
//  Created by Anh Tuấn Nguyễn on 5/3/26.
//

import Foundation

/// A single line of rich text content, composed of inline items.
public enum RTSection {
    /// A line containing one or more inline items, with optional paragraph style.
    case items([RTItem], style: RTSectionStyle? = nil)
    /// A blank line separator.
    case spacing
}
