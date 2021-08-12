//
//  LinkFooterView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-11.
//

import Foundation
import UIKit

class LinkFooterView: UITableViewHeaderFooterView, ReusableView {
  private let textView = UITextView()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.configureContents()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureContents() {
    self.textView.isEditable = false
    self.textView.isScrollEnabled = false
    self.textView.backgroundColor = .clear
    self.textView.textContainerInset = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: -5.0)  // hard-coded

    self.textView.translatesAutoresizingMaskIntoConstraints = false

    self.contentView.addSubview(self.textView)

    NSLayoutConstraint.activate([
      self.textView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
      self.textView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
      self.textView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
      self.textView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor)
    ])
  }

  func bind(to text: String, link: URL) {
    let attributedString = NSAttributedString(
      string: text,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .footnote),
        .foregroundColor: UIColor.link,
        .link: link
      ]
    )

    let linkAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.link,
      .underlineStyle: 0
    ]

    self.textView.linkTextAttributes = linkAttributes
    self.textView.attributedText = attributedString
  }
}
