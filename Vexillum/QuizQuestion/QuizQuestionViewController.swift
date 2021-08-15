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

  private var selectedCountry: Country?

  var questionIndex: Int!
  var viewModel: QuizViewModel!

  var questionData: Quiz.Question {
    self.viewModel.quiz.questions[self.questionIndex]
  }

  override func viewDidLoad() {
    let image = UIImage(named: questionData.country.flagImageName)!
    let imageView = UIImageView(image: image).apply(self.configureImageView(_:))

    let width = self.view.layoutMarginsGuide.layoutFrame.width - 32
    let imageWidth = image.size.width
    let imageHeight = image.size.height
    let newHeight = imageHeight * (width / imageWidth)

    self.view.addSubview(imageView)

    let label = UILabel().apply(self.configureLabel(_:))

    self.view.addSubview(label)

    let grid = GridView(
      self.questionData.allOptions,
      numberOfColumns: 2,
      spacing: 10.0,
      provider: self.optionView(for:)
    )

    grid.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(grid)

    imageView.constrain(to: self.view.layoutMarginsGuide, on: [.horizontal, .top])
    imageView.constrain(to: min(300, newHeight), on: .height)
    grid.constrain(to: self.view.layoutMarginsGuide, on: .horizontal)
    label.constrain(to: self.view.layoutMarginsGuide, on: .horizontal)

    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
      grid.topAnchor.constraint(equalTo: label.bottomAnchor)
    ])

    self.view.backgroundColor = .systemBackground

    self.feedbackGenerator.prepare()

    self.view.layoutMargins = .zero
  }

  @objc private func handleOptionTap(sender: UITapGestureRecognizer) {
    guard self.selectedCountry == nil else {
      return
    }

    // swiftlint:disable:next force_cast
    let view = sender.view as! QuizQuestionOptionView
    let isCorrect = self.questionData.country == view.country
    self.selectedCountry = view.country

    view.setSelected(isCorrect: isCorrect)

    self.feedbackGenerator.notificationOccurred(isCorrect ? .success : .error)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.viewModel.currentQuestionIndex += 1
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
    label.font = .preferredFont(forTextStyle: .headline)
  }

  private func optionView(for country: Country) -> QuizQuestionOptionView {
    let view = QuizQuestionOptionView(country: country)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOptionTap(sender:)))

    view.addGestureRecognizer(tapGestureRecognizer)
    view.layoutIfNeeded()

    return view
  }
}

struct QuizQuestionViewController_Previews: PreviewProvider {
  static func country(withName name: String) -> Country {
    CountryProvider.shared.allCountries.first {
      $0.name.common == name
    }!
  }

  static let preparedVc: QuizQuestionViewController = {
    let result = QuizQuestionViewController()
    result.viewModel = .init(using: .shared)
    result.questionIndex = 0

    return result
  }()

  static var previews: some View {
    Preview(
      for: preparedVc,
      navigationControllerStyle: .none
    )
    .edgesIgnoringSafeArea(.all).previewDevice(nil)
  }
}
