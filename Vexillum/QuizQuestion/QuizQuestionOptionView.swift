//
//  QuizQuestionOptionView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import UIKit

class QuizQuestionOptionView: UIView {
  private let label = UILabel()

  let option: QuizQuestion.Option

  init(option: QuizQuestion.Option) {
    self.option = option
    super.init(frame: .zero)

    self.label.apply(self.configureLabel(_:))
    self.layer.apply(self.configureLayer(_:))

    self.addSubview(self.label)

    self.constrain(to: 90, on: .height)
    self.label.constrain(to: self.layoutMarginsGuide, on: .horizontal, constant: 10)
    self.label.constrain(to: self.layoutMarginsGuide, on: .vertical)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setSelected(isCorrect: Bool) {
    let color: UIColor = isCorrect ? .systemGreen : .systemRed

    self.layer.borderColor = color.cgColor
    self.label.textColor = color
    self.backgroundColor = color.withAlphaComponent(0.1)
  }

  private func configureLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 20.0, weight: .semibold)
    label.textColor = .label
    label.text = self.option.name
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 2
    label.translatesAutoresizingMaskIntoConstraints = false
  }

  private func configureLayer(_ layer: CALayer) {
    layer.borderColor = UIColor.systemGray4.cgColor
    layer.borderWidth = 1.5
    layer.cornerRadius = 16.0
  }
}
