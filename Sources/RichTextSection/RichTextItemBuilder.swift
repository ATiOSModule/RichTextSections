//
//  File.swift
//  RichTextSection
//
//  Created by Anh Tuấn Nguyễn on 4/3/26.
//
import Foundation
import UIKit

/// Builds inline items within a single section (line).
public final class RTItemBuilder {
    
    private(set) var items: [RTItem] = []
    
    // MARK: - Add Items
    
    @discardableResult
    public func text(_ string: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        items.append(.text(string, font: font, color: color))
        return self
    }
    
    @discardableResult
    public func bold(_ string: String, size: CGFloat? = nil, color: UIColor? = nil) -> Self {
        items.append(.bold(string, size: size, color: color))
        return self
    }
    
    @discardableResult
    public func italic(_ string: String, size: CGFloat? = nil, color: UIColor? = nil) -> Self {
        items.append(.italic(string, size: size, color: color))
        return self
    }
    
    @discardableResult
    public func image(_ image: UIImage, size: CGSize? = nil) -> Self {
        items.append(.image(image, size: size))
        return self
    }
    
    @discardableResult
    public func html(_ string: String, styles: [RTHTMLStyle] = []) -> Self {
        items.append(.html(string, styles: styles))
        return self
    }
    
    @discardableResult
    public func link(_ text: String, url: URL? = nil, handler: ((String, URL?) -> Void)? = nil) -> Self {
        items.append(.link(text, url: url, handler: handler))
        return self
    }
    
    @discardableResult
    public func strikethrough(_ string: String, size: CGFloat? = nil, color: UIColor? = nil) -> Self {
        items.append(.strikethrough(string, size: size, color: color))
        return self
    }
}
