//
//  QuizQuestionViewController.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-13.
//

import Foundation
import UIKit
import PreviewView
import SwiftUI

class QuizQuestionViewController: UIViewController {
  private let feedbackGenerator = UINotificationFeedbackGenerator()

  private var isLocked = false

  var viewModel: QuizQuestionViewModel!

  convenience init(using viewModel: QuizQuestionViewModel) {
    self.init()

    self.viewModel = viewModel
  }

  override func viewDidLoad() {
    let image = self.viewModel.correctFlagImage()
    let imageView = UIImageView(image: image).apply(self.configureImageView(_:))

    self.view.addSubview(imageView)

    let label = UILabel().apply(self.configureLabel(_:))

    self.view.addSubview(label)

    let grid = GridView(
      self.viewModel.options(),
      numberOfColumns: 2,
      spacing: 10.0,
      provider: self.optionView(for:)
    )

    grid.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(grid)

    self.view.backgroundColor = .systemBackground

    self.feedbackGenerator.prepare()

    self.configureConstraints(imageView: imageView, grid: grid, label: label)

    self.view.layoutMargins = .zero
  }

  private func configureConstraints(imageView: UIImageView, grid: UIView, label: UIView) {
    let dummyView = UIView()
    dummyView.isHidden = true
    dummyView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(dummyView)
    dummyView.constrain(to: self.view, on: .horizontal)

    let width = self.view.layoutMarginsGuide.layoutFrame.width - 32
    let imageWidth = imageView.image!.size.width
    let imageHeight = imageView.image!.size.height
    let newHeight = imageHeight * (width / imageWidth)

    imageView.constrain(to: self.view.layoutMarginsGuide, on: .horizontal)
    imageView.constrain(to: min(300, newHeight), on: .height)
    grid.constrain(to: self.view.layoutMarginsGuide, on: .horizontal)
    grid.constrain(to: self.view.layoutMarginsGuide, on: .bottom, constant: 110)
    label.constrain(to: self.view.layoutMarginsGuide, on: .horizontal)

    dummyView.constrain(to: self.view.layoutMarginsGuide, on: .top)

    imageView.constrain(to: dummyView, on: .centerY)

    NSLayoutConstraint.activate([
      dummyView.bottomAnchor.constraint(equalTo: label.topAnchor),
      label.bottomAnchor.constraint(equalTo: grid.topAnchor, constant: -20)
    ])
  }

  @objc private func handleOptionTap(sender: UITapGestureRecognizer) {
    guard !self.isLocked else {
      return
    }
    self.isLocked = true

    // swiftlint:disable:next force_cast
    let view = sender.view as! QuizQuestionOptionView

    self.viewModel.submitAnswer(view.option) { isCorrect in
      self.feedbackGenerator.notificationOccurred(isCorrect ? .success : .error)
      view.setSelected(isCorrect: isCorrect)
    }
  }

  private func getScaledSize(maxSize: CGSize, imageSize: CGSize) -> CGSize {
    let aspectRatio = imageSize.height / imageSize.width
    return CGSize(width: maxSize.width, height: maxSize.width * aspectRatio)
  }

  private func configureImageView(_ imageView: UIImageView) {
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 16.0
    imageView.clipsToBounds = true
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = UIColor.systemGray4.cgColor
    imageView.layer.borderWidth = 1.0
  }

  private func configureLabel(_ label: UILabel) {
    label.text = "Which country has this flag?"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 20.0, weight: .bold)
  }

  private func optionView(for option: QuizQuestion.Option) -> QuizQuestionOptionView {
    let view = QuizQuestionOptionView(option: option)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOptionTap(sender:)))

    view.addGestureRecognizer(tapGestureRecognizer)
    view.layoutIfNeeded()

    return view
  }
}

struct QuizQuestionViewController_Previews: PreviewProvider {
  static func option(withName name: String) -> QuizQuestion.Option {
    let country = CountryProvider.shared.allCountries.first { $0.name.common == name }!
    return .init(
      id: country.id,
      flagImageName: country.flagImageName,
      name: country.name.common,
      flag: country.flag
    )
  }

  static var viewModel: QuizQuestionViewModel {
    let question = QuizQuestion(
      correctOption: option(withName: "Nepal"),
      alternateOptions: [
        option(withName: "Australia"),
        option(withName: "France"),
        option(withName: "Germany")
      ]
    )

    return .init(for: question, with: .init())
  }

  static var previews: some View {
    Preview(
      for: QuizQuestionViewController(using: viewModel),
      navigationControllerStyle: .none
    )
    .edgesIgnoringSafeArea(.all).previewDevice(nil)
  }
}
