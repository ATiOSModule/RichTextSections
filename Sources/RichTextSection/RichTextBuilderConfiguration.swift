//
//  File.swift
//  RichTextSection
//
//  Created by Anh Tuấn Nguyễn on 4/3/26.
//

import Foundation
import UIKit

/// Global style configuration for `RTBuilder`.
///
/// Usage:
/// ```swift
/// // Reusable config
/// let config = RTBuilderConfiguration(
///     font: .interRegular(14),
///     color: .white,
///     alignment: .center,
///     lineSpacing: 4,
///     linkColor: UIColor(from: "#2391FF"),
///     linkUnderline: true
/// )
///
/// // Apply to multiple builders
/// let result1 = RTBuilder(config: config)
///     .text("Message 1")
///     .build()
///
/// let result2 = RTBuilder(config: config)
///     .text("Message 2")
///     .bold("Important")
///     .build()
/// ```
public struct RTBuilderConfiguration: @unchecked Sendable {
    public var font: UIFont
    public var italicFont: UIFont?
    public var color: UIColor
    public var alignment: NSTextAlignment
    public var lineSpacing: CGFloat
    public var linkColor: UIColor
    public var linkUnderline: Bool
    
    public init(font: UIFont = .systemFont(ofSize: 14),
                italicFont: UIFont? = nil,
                color: UIColor = .white,
                alignment: NSTextAlignment = .center,
                lineSpacing: CGFloat = 2,
                linkColor: UIColor = .systemBlue,
                linkUnderline: Bool = true) {
        self.font = font
        self.italicFont = italicFont
        self.color = color
        self.alignment = alignment
        self.lineSpacing = lineSpacing
        self.linkColor = linkColor
        self.linkUnderline = linkUnderline
    }
    
    /// A sensible default configuration.
    public static let `default` = RTBuilderConfiguration()
}
