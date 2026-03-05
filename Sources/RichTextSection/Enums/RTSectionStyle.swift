//
//  RTSectionStyle.swift
//  RichTextSection
//
//  Created by Anh Tuấn Nguyễn on 5/3/26.
//
import Foundation
import UIKit

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
