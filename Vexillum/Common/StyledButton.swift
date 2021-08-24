//
//  StyledButton.swift
//  StyledButton
//
//  Created by Richard Robinson on 2021-08-18.
//

import Foundation
import UIKit
import PreviewView
import SwiftUI

extension UIColor {
  // swiftlint:disable:next large_tuple
  var hsbComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    self.getHue(
      &hue,
      saturation: &saturation,
      brightness: &brightness,
      alpha: &alpha
    )

    return (hue, saturation, brightness, alpha)
  }

  func with(
    hueDelta: CGFloat = 0,
    saturationDelta: CGFloat = 0,
    brightnessDelta: CGFloat = 0
  ) -> UIColor {
    let (hue, saturation, brightness, alpha) = self.hsbComponents

    return UIColor(
      hue: hue + hueDelta,
      saturation: saturation + saturationDelta,
      brightness: brightness + brightnessDelta,
      alpha: alpha
    )
  }
}

class StyledButton: UIButton {
  enum Style {
    case tinted, filled, gray
  }

  private let action: () -> Void

  func updateBackgroundColor() {
    let bgColor = self.normalBackgroundColor!

    guard self.isHighlighted else {
      self.backgroundColor = bgColor
      return
    }

    let shouldDarken = self.traitCollection.userInterfaceStyle == .dark && bgColor.hsbComponents.alpha <= 0.25
    let delta = shouldDarken ? -0.2 : 0.2

    self.backgroundColor = bgColor.with(brightnessDelta: delta)
  }

  override var isHighlighted: Bool {
    didSet {
      self.updateBackgroundColor()
    }
  }

  private func adjustInsets(withImageTitlePadding padding: CGFloat) {
    self.contentEdgeInsets = UIEdgeInsets(
      top: self.contentEdgeInsets.top,
      left: self.contentEdgeInsets.left,
      bottom: self.contentEdgeInsets.bottom,
      right: self.contentEdgeInsets.right + padding
    )

    self.titleEdgeInsets = UIEdgeInsets(
      top: 0,
      left: padding,
      bottom: 0,
      right: -padding
    )
  }

  private var normalBackgroundColor: UIColor!

  init(style: Style, color: UIColor, _ action: @escaping () -> Void) {
    self.action = action
    super.init(frame: .zero)

    self.layer.cornerRadius = 10.0 // 6.0
    self.adjustsImageWhenHighlighted = false

    let isDarkMode = self.traitCollection.userInterfaceStyle == .dark

    switch style {
    case .filled:
      self.normalBackgroundColor = color
      self.setTitleColor(.white, for: .normal)
      self.tintColor = .white

    case .tinted:
      self.normalBackgroundColor = isDarkMode
        ? color.withAlphaComponent(0.25)
        : color.withAlphaComponent(0.18)
      self.setTitleColor(color, for: .normal)
      self.tintColor = color

    case .gray:
      self.normalBackgroundColor = .secondarySystemFill
      self.setTitleColor(color, for: .normal)
      self.tintColor = color
    }

    self.backgroundColor = self.normalBackgroundColor

    self.adjustInsets(withImageTitlePadding: 10)

    self.addTarget(self, action: #selector(self.onAction(_:)), for: .touchUpInside)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func onAction(_ sender: UIButton) {
    self.action()
  }
}
