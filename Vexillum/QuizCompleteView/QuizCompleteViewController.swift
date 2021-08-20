//
//  QuizCompleteViewController.swift
//  QuizCompleteViewController
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import UIKit
import SwiftUI
import Shiny
import PreviewView
import ConfettiView

class GradientLabel: UILabel {
  var gradientColors: [CGColor] = []

  override func layoutSubviews() {
    self.textColor = self.gradientColor()
  }

  private func gradientColor() -> UIColor? {
    let currentContext = UIGraphicsGetCurrentContext()
    currentContext?.saveGState()
    defer { currentContext?.restoreGState() }

    let size = self.bounds.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    let gradient = CGGradient(
      colorsSpace: CGColorSpaceCreateDeviceRGB(),
      colors: self.gradientColors as CFArray,
      locations: nil
    )

    let context = UIGraphicsGetCurrentContext()
    context?.drawLinearGradient(
      gradient!,
      start: .zero,
      end: CGPoint(x: size.width, y: size.height),
      options: []
    )

    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return UIColor(patternImage: gradientImage!)
  }
}

extension UIFont {
  class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
    let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
    let font: UIFont

    if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
      font = UIFont(descriptor: descriptor, size: size)
    } else {
      font = systemFont
    }
    return font
  }
}

class QuizCompleteViewController: UIViewController {
  private var viewModel: QuizViewModel!

  let confetti = ConfettiView().apply {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  convenience init(using viewModel: QuizViewModel) {
    self.init()
    self.viewModel = viewModel
  }

  override func viewDidLoad() {
    let numberFormatter = NumberFormatter().apply {
      $0.maximumFractionDigits = 0
      $0.numberStyle = .percent
    }

    let percentText = numberFormatter.string(from: NSNumber(value: self.viewModel.percentCorrect()))

    let colors: [UIColor] = [
      .systemGreen,
      .systemBlue,
      .systemPurple,
      .systemPink
    ]

    let textLabel = UILabel().apply {
      $0.text = "Congrats! You scored"
      $0.font = .systemFont(ofSize: 28.0, weight: .bold)
      $0.textAlignment = .center
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let gradientLabel = GradientLabel().apply {
      $0.text = percentText
      $0.textColor = .black
      $0.font = .rounded(ofSize: 110.0, weight: .bold)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.textAlignment = .center
      $0.gradientColors = colors.map(\.cgColor)
    }

    self.view.backgroundColor = .systemBackground

    self.view.addSubview(textLabel)

    self.view.addSubview(gradientLabel)

    textLabel.constrain(to: self.view, on: [.horizontal])
    textLabel.constrain(to: self.view, on: .top, constant: 200)

    gradientLabel.constrain(to: self.view, on: .horizontal)

    NSLayoutConstraint.activate([
      gradientLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20)
    ])

    let stackView = UIStackView().apply {
      $0.axis = .horizontal
      $0.distribution = .fillEqually
      $0.alignment = .center
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let againButton = StyledButton(style: .filled, color: .systemBlue, self.onAgainButtonTap).apply {
      $0.setImage(.symbol("arrow.counterclockwise"), for: .normal)
      $0.setTitle("Try Again", for: .normal)
    }

    let doneButton = StyledButton(style: .tinted, color: .systemBlue, self.onDoneButtonTap).apply {
      $0.setImage(.symbol("xmark"), for: .normal)
      $0.setTitle("Done", for: .normal)
    }

    let shareButton = UIButton.systemButton(
      with: .symbol("square.and.arrow.up"),
      target: self,
      action: #selector(self.onShareButtonTap(_:))
    )

    shareButton.translatesAutoresizingMaskIntoConstraints = false

    doneButton.translatesAutoresizingMaskIntoConstraints = false

    againButton.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(againButton)
    stackView.addArrangedSubview(doneButton)
    stackView.spacing = 24

    againButton.constrain(to: stackView, on: .height)
    doneButton.constrain(to: stackView, on: .height)

    self.view.addSubview(stackView)

    stackView.constrain(to: self.view, on: .horizontal, constant: 24)
    stackView.constrain(to: 44, on: .height)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: gradientLabel.bottomAnchor, constant: 300)
    ])

    self.view.addSubview(self.confetti)

    self.confetti.constrain(to: self.view, on: .edges)
  }

  private func onAgainButtonTap() {
    let confettiContent = self.viewModel.confettiContent()

    self.confetti.emit(with: confettiContent, for: 3.0)
  }

  private func onDoneButtonTap() {
    self.dismiss(animated: true, completion: nil)
  }

  @objc private func onShareButtonTap(_ sender: UIButton) {
    let bounds = UIScreen.main.bounds
    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
    self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
    let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    let activityViewController = UIActivityViewController(
      activityItems: [screenshot, "Hello"],
      applicationActivities: nil
    )

    self.present(activityViewController, animated: true, completion: nil)
  }
}

struct QuizCompleteViewController_Previews: PreviewProvider {
  static var previews: some View {
    Preview(
      for: QuizCompleteViewController(using: QuizViewModel()),
      navigationControllerStyle: .none
    ).preferredColorScheme(.light)
    .edgesIgnoringSafeArea(.all).previewDevice(nil)
  }
}

extension UIImage {
  static func symbol(_ systemName: String) -> Self {
    Self(systemName: systemName)!
  }
}
