//
//  SectionSymbolHeaderView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-11.
//

import Foundation
import UIKit

class SectionSymbolHeaderView: UITableViewHeaderFooterView, ReusableView {
  private let label = UILabel()
  private let imageView = UIImageView()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.configureContents()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureContents() {
    self.label.font = .preferredFont(forTextStyle: .footnote)
    self.label.textColor = .gray

    self.imageView.preferredSymbolConfiguration = .init(font: self.label.font)
    self.imageView.tintColor = .gray
    self.imageView.translatesAutoresizingMaskIntoConstraints = false
    self.label.translatesAutoresizingMaskIntoConstraints = false

    self.contentView.addSubview(self.imageView)
    self.contentView.addSubview(self.label)

    self.imageView.constrain(to: self.contentView.layoutMarginsGuide, on: [.leading, .vertical])

    NSLayoutConstraint.activate([
      self.imageView.firstBaselineAnchor.constraint(equalTo: self.label.firstBaselineAnchor),
      self.label.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 3.0)
    ])
  }

  func bind(to section: CountryViewController.Section, for country: Country) {
    let (text, symbolName) = section.header(for: country)
    let symbol = UIImage(systemName: symbolName)

    self.imageView.image = symbol
    self.label.text = text.uppercased()
  }
}
