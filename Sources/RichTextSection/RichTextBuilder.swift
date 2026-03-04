// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

/// A declarative builder for composing `NSAttributedString` from sections of inline items.
///
/// Usage:
/// ```swift
/// let result = RTBuilder()
///     .font(.systemFont(ofSize: 14))
///     .color(.white)
///     .section {
///         $0.image(UIImage(systemName: "star.fill")!)
///            .text(" ")
///            .bold("Welcome")
///     }
///     .section {
///         $0.text("Check out the ")
///            .link("Docs", url: docsURL) { _, _ in }
///            .text(" for more info.")
///     }
///     .spacing()
///     .section {
///         $0.italic("Last updated: 2026")
///     }
///     .build()
///
/// textView.attributedText = result.attributedString
/// ```
public final class RTBuilder {
    
    // MARK: - Configuration
    
    private var sections: [RTSection] = []
    private var baseFont: UIFont = .systemFont(ofSize: 14)
    private var italicFont: UIFont?
    private var textColor: UIColor = .white
    private var textAlignment: NSTextAlignment = .center
    private var textLineSpacing: CGFloat = 2
    private var linkTextColor: UIColor = .systemBlue
    private var linkUnderline: Bool = true
    
    // MARK: - Init
    
    public init() {}
    
    /// Creates a builder pre-configured with the given configuration.
    public init(config: RTBuilderConfiguration) {
        self.baseFont = config.font
        self.italicFont = config.italicFont
        self.textColor = config.color
        self.textAlignment = config.alignment
        self.textLineSpacing = config.lineSpacing
        self.linkTextColor = config.linkColor
        self.linkUnderline = config.linkUnderline
    }
    
    // MARK: - Global Style
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        baseFont = font
        return self
    }
    
    @discardableResult
    public func italic(font: UIFont) -> Self {
        italicFont = font
        return self
    }
    
    @discardableResult
    public func color(_ color: UIColor) -> Self {
        textColor = color
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func lineSpacing(_ spacing: CGFloat) -> Self {
        textLineSpacing = spacing
        return self
    }
    
    @discardableResult
    public func linkColor(_ color: UIColor) -> Self {
        linkTextColor = color
        return self
    }
    
    @discardableResult
    public func linkUnderline(_ enabled: Bool) -> Self {
        linkUnderline = enabled
        return self
    }
    
    // MARK: - Add Sections
    /// Appends a section built from a closure. Each section renders as a single line.
    @discardableResult
    public func section(_ builder: (RTItemBuilder) -> RTItemBuilder) -> Self {
        let itemBuilder = RTItemBuilder()
        _ = builder(itemBuilder)
        sections.append(.items(itemBuilder.items))
        return self
    }
    
    /// Appends a blank line separator.
    @discardableResult
    public func spacing() -> Self {
        sections.append(.spacing)
        return self
    }
    
    /// Appends a raw `RTSection` directly.
    @discardableResult
    public func section(_ section: RTSection) -> Self {
        sections.append(section)
        return self
    }
    
}

// MARK: - Build Logic
extension RTBuilder {
    
    public func build() -> RTResult {
        
        var linkHandlers: [URL: (String, URL?) -> Void] = [:]
        var linkTextMap: [URL: (text: String, originalURL: URL?)] = [:]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = textLineSpacing
        
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: baseFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let result = NSMutableAttributedString()
        
        for (index, section) in sections.enumerated() {
            switch section {
            case .items(let items):
                for item in items {
                    let attributed = buildItem(item,
                                               baseAttributes: baseAttributes,
                                               linkHandlers: &linkHandlers,
                                               linkTextMap: &linkTextMap)
                    result.append(attributed)
                }
                
            case .spacing:
                result.append(NSAttributedString(string: "\n\n", attributes: baseAttributes))
            }
            
            // Newline between sections, skip around .spacing
            if index < sections.count - 1 {
                let needsNewline: Bool = {
                    if case .spacing = section { return false }
                    if case .spacing = sections[index + 1] { return false }
                    return true
                }()
                if needsNewline {
                    result.append(NSAttributedString(string: "\n", attributes: baseAttributes))
                }
            }
        }
        
        return RTResult(
            attributedString: result,
            linkHandlers: linkHandlers,
            linkTextMap: linkTextMap
        )
    }
    
}

// MARK: - Private Helpers
private extension RTBuilder {
    
    func buildItem(_ item: RTItem,
                           baseAttributes: [NSAttributedString.Key: Any],
                           linkHandlers: inout [URL: (String, URL?) -> Void],
                           linkTextMap: inout [URL: (text: String, originalURL: URL?)]) -> NSAttributedString {
        switch item {
        case .text(let string, let font, let color):
            var attrs = baseAttributes
            if let font = font { attrs[.font] = font }
            if let color = color { attrs[.foregroundColor] = color }
            return NSAttributedString(string: string, attributes: attrs)
            
        case .bold(let string, let size, let color):
            var attrs = baseAttributes
            attrs[.font] = resolveBoldFont(withSize: size ?? baseFont.pointSize)
            if let color = color { attrs[.foregroundColor] = color }
            return NSAttributedString(string: string, attributes: attrs)
            
        case .italic(let string, let size, let color):
            var attrs = baseAttributes
            attrs[.font] = resolveItalicFont(withSize: size ?? baseFont.pointSize)
            if let color = color { attrs[.foregroundColor] = color }
            return NSAttributedString(string: string, attributes: attrs)
            
        case .image(let image, let size):
            let attachment = NSTextAttachment()
            attachment.image = image
            let displaySize = size ?? defaultImageSize()
            attachment.bounds = CGRect(
                origin: CGPoint(x: 0, y: (baseFont.capHeight - displaySize.height) / 2),
                size: displaySize
            )
            return NSAttributedString(attachment: attachment)
            
        case .html(let htmlString, let styles):
            return convertHTML(htmlString, styles: styles) ?? NSAttributedString()
            
        case .link(let text, let url, let handler):
            let linkURL = url ?? URL(string: "rtbuilder://link/\(UUID().uuidString)")!
            
            var attrs = baseAttributes
            attrs[.foregroundColor] = linkTextColor
            attrs[.link] = linkURL
            if linkUnderline {
                attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            
            if let handler = handler {
                linkHandlers[linkURL] = handler
            }
            linkTextMap[linkURL] = (text: text, originalURL: url)
            
            return NSAttributedString(string: text, attributes: attrs)
        }
    }
    
    func resolveBoldFont(withSize size: CGFloat) -> UIFont {
        let descriptor = baseFont.fontDescriptor
        if let boldDescriptor = descriptor.withSymbolicTraits(.traitBold) {
            return UIFont(descriptor: boldDescriptor, size: size)
        }
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    func resolveItalicFont(withSize size: CGFloat) -> UIFont {
        if let explicit = italicFont {
            return explicit.withSize(size)
        }
        let descriptor = baseFont.fontDescriptor
        if let italicDescriptor = descriptor.withSymbolicTraits(.traitItalic) {
            return UIFont(descriptor: italicDescriptor, size: size)
        }
        return baseFont.withSize(size)
    }
    
    func defaultImageSize() -> CGSize {
        let side = baseFont.lineHeight
        return CGSize(width: side, height: side)
    }
    
    func convertHTML(_ html: String, styles: [RTHTMLStyle]) -> NSAttributedString? {
        let trimmed = html.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        let wrapped: String
        if styles.isEmpty {
            wrapped = html
        } else {
            let inlineCSS = styles.map { $0.htmlTag }.joined(separator: ";")
            wrapped = "<span style=\"\(inlineCSS)\">\(html)</span>"
        }
        
        guard let data = wrapped.data(using: .utf8) else { return nil }
        
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
}
