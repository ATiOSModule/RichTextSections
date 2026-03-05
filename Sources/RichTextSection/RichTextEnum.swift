//
//  File.swift
//  RichTextSection
//
//  Created by Anh Tuấn Nguyễn on 4/3/26.
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

/// A single line of rich text content, composed of inline items.
public enum RTSection {
    /// A line containing one or more inline items, with optional paragraph style.
    case items([RTItem], style: RTSectionStyle? = nil)
    /// A blank line separator.
    case spacing
}

/// Per-section paragraph style overrides.
///
/// When applied to a section, these values override the builder's
/// global `alignment` and add paragraph-level formatting like indentation.
///
/// Usage:
/// ```swift
/// .section(style: RTSectionStyle(alignment: .left, indent: 16)) {
///     $0.text("This text is left-aligned and indented.")
/// }
/// ```
public struct RTSectionStyle {
    /// Text alignment override for this section. `nil` uses the builder's global alignment.
    public var alignment: NSTextAlignment?
    /// First-line head indent in points. Default is `0`.
    public var firstLineIndent: CGFloat
    /// Head indent (left margin) in points. Default is `0`.
    public var indent: CGFloat
    /// Tail indent (right margin, negative for inset from right). Default is `0`.
    public var tailIndent: CGFloat
    /// Line spacing override. `nil` uses the builder's global line spacing.
    public var lineSpacing: CGFloat?
    
    public init(alignment: NSTextAlignment? = nil,
                firstLineIndent: CGFloat = 0,
                indent: CGFloat = 0,
                tailIndent: CGFloat = 0,
                lineSpacing: CGFloat? = nil) {
        self.alignment = alignment
        self.firstLineIndent = firstLineIndent
        self.indent = indent
        self.tailIndent = tailIndent
        self.lineSpacing = lineSpacing
    }
}

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
