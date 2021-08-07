//
//  FlagListTableViewCell.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-04.
//

import Foundation
import UIKit

class FlagListTableViewCell: UITableViewCell, ReusableView {
  private let flagImageView = UIImageView()
  private var cellHeightConstraint: NSLayoutConstraint!

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.cellHeightConstraint = self.flagImageView.heightAnchor.constraint(equalToConstant: 0)
    self.cellHeightConstraint.isActive = true

    self.flagImageView.contentMode = .scaleAspectFit
    self.flagImageView.translatesAutoresizingMaskIntoConstraints = false

    self.contentView.addSubview(self.flagImageView)

    self.flagImageView.pinEdges(to: self.contentView)
  }

  @available(*, unavailable)
  required init?(
    coder _: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(to country: Country) {
    let image = UIImage(named: country.flagImageName)!
    self.flagImageView.image = image

    let imageViewWidth = self.contentView.frame.width
    let imageWidth = CGFloat(self.flagImageView.image!.cgImage!.width)
    let imageHeight = CGFloat(self.flagImageView.image!.cgImage!.height)

    let scaledHeight = imageHeight * (imageViewWidth / imageWidth)
    self.cellHeightConstraint.constant = scaledHeight
  }
}
