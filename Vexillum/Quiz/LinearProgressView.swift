//
//  LinearProgressView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import UIKit

class LinearProgressView: UIView {
  var color: UIColor = .systemBlue
  var cornerRadius: CGFloat = 0.0

  var progress: CGFloat = 0.0 {
    didSet {
      self.setNeedsDisplay()
    }
  }

  private let progressLayer = CALayer()

  init() {
    super.init(frame: .zero)
    self.layer.addSublayer(self.progressLayer)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    let backgroundMask = CAShapeLayer().apply {
      $0.path = UIBezierPath(roundedRect: rect, cornerRadius: self.cornerRadius).cgPath
    }

    self.layer.mask = backgroundMask

    let progressRect = CGRect(
      origin: .zero,
      size: CGSize(width: rect.width * self.progress, height: rect.height)
    )

    self.progressLayer.apply {
      $0.backgroundColor = self.color.cgColor
      $0.frame = progressRect
      $0.cornerRadius = self.cornerRadius
    }

    self.layer.addSublayer(self.progressLayer)
  }
}
