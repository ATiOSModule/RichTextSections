//
//  File.swift
//  RichTextSection
//
//  Created by Anh Tuấn Nguyễn on 5/3/26.
//

import Foundation
import UIKit

/// An inline content unit within a section.
public enum RTItem {
    /// Regular body text with optional font and color override.
    case text(String, font: UIFont? = nil, color: UIColor? = nil)
    /// Bold text with optional size and color override.
    case bold(String, size: CGFloat? = nil, color: UIColor? = nil)
    /// Italic text with optional size and color override.
    case italic(String, size: CGFloat? = nil, color: UIColor? = nil)
    /// Inline image (e.g. icon, badge) with optional display size.
    case image(UIImage, size: CGSize? = nil)
    /// HTML formatted text with optional inline styles.
    case html(String, styles: [RTHTMLStyle])
    /// Tappable link with display text, URL, and optional tap handler.
    case link(String, url: URL? = nil, handler: ((String, URL?) -> Void)? = nil)
    /// Strikethrough text with optional size and color override.
    case strikethrough(String, size: CGFloat? = nil, color: UIColor? = nil)
}
