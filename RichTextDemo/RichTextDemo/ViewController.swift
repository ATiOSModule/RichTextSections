//
//  ViewController.swift
//  RichTextDemo
//
//  Created by Anh Tuấn Nguyễn on 4/3/26.
//

import UIKit
import RichTextSection

class ViewController: UIViewController {
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = true
        tv.backgroundColor = .clear
        tv.textContainerInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        tv.textContainer.lineFragmentPadding = 0
        tv.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var linkResult: RTResult?
    
    private let config = RTBuilderConfiguration(
        font: .systemFont(ofSize: 14),
        color: .white,
        alignment: .center,
        lineSpacing: 4,
        linkColor: .systemBlue
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        setupTextView()
        buildDemo()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        textView.delegate = self
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func buildDemo() {
        let result = RTBuilder(config: config)
            // Line 1: icon + title
            .section {
                $0.image(UIImage(systemName: "star.fill")!, size: CGSize(width: 20, height: 20))
                  .text(" ")
                  .bold("Welcome to RichTextSections", size: 18, color: .systemYellow)
            }
            .spacing()
        
            // Line 2: mixed inline text
            .section {
                $0.text("Build ")
                  .bold("rich attributed text")
                  .text(" from composable sections.")
            }
        
            // Line 3: italic note
            .section {
                $0.italic("Supports text, bold, italic, image, HTML, and tappable links.", size: 12, color: .lightGray)
            }
            .spacing()
        
            // Line 4: strikethrough — pricing example
            .section {
                $0.text("Price: ")
                  .strikethrough("$9.99", color: .systemRed)
                  .text(" ")
                  .bold("$4.99", color: .systemGreen)
                  .text(" (50% off!)")
            }
            .spacing()
        
            // Line 5: left-aligned section with indent
            .section(style: RTSectionStyle(alignment: .left, indent: 24)) {
                $0.bold("Note: ", color: .systemOrange)
                  .text("This section is left-aligned with a 24pt indent. Useful for callouts and side notes.")
            }
            .spacing()
        
            // Line 6: right-aligned section
            .section(style: RTSectionStyle(alignment: .right)) {
                $0.italic("— The RichTextSections Team", size: 12, color: .lightGray)
            }
            .spacing()
        
            // Line 7: left-aligned with first line indent
            .section(style: RTSectionStyle(alignment: .left, firstLineIndent: 32)) {
                $0.text("First-line indent is great for paragraph-style text. The first line starts further in while subsequent lines wrap normally.")
            }
            .spacing()
        
            // Line 8: links
            .section {
                $0.text("Check out the ")
                  .link("GitHub Repository", url: URL(string: "https://github.com")) { text, url in
                      print("Tapped: \(text) → \(url?.absoluteString ?? "nil")")
                  }
                  .text(" and ")
                  .link("Documentation", url: URL(string: "https://example.com/docs")) { text, url in
                      print("Tapped: \(text) → \(url?.absoluteString ?? "nil")")
                  }
            }
            .spacing()
        
            // Line 9: link without URL
            .section {
                $0.link("Send Feedback") { text, _ in
                    print("Tapped: \(text) — no URL, handle custom action")
                }
            }
            .build()
        
        linkResult = result
        textView.attributedText = result.attributedString
    }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        guard let result = linkResult else { return false }
        
        if let handler = result.linkHandlers[URL],
           let info = result.linkTextMap[URL] {
            handler(info.text, info.originalURL)
        }
        
        return false
    }
}
