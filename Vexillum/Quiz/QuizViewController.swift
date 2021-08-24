//
//  QuizViewController.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import UIKit
import Combine

protocol P {}

extension P {
  func foo() -> Self {
    return self
  }
}

class QuizViewController: UIViewController {
  private let viewModel = QuizViewModel()
  private var cancellables = Set<AnyCancellable>()

  private let pageController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal,
    options: nil
  )

  private let progressBar = LinearProgressView().apply {
    $0.cornerRadius = 4.0
    $0.color = .systemIndigo
    $0.backgroundColor = .systemGray5
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private var closeButton: UIButton!

  @objc private func onCloseButtonTap(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.closeButton = UIButton.systemButton(
      with: .symbol("xmark.circle.fill", withConfiguration: .init(pointSize: 20, weight: .regular, scale: .large)),
      target: self,
      action: #selector(self.onCloseButtonTap(_:))
    ).apply {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.tintColor = .systemIndigo
    }

    self.view.addSubview(self.closeButton)

    self.view.addSubview(self.progressBar)

    self.addChild(self.pageController)
    self.view.addSubview(self.pageController.view)

    self.view.backgroundColor = .systemBackground

    self.presentQuestion(self.viewModel.currentQuestion!)

    self.viewModel.$currentQuestion
      .sink { [weak self] question in
        if let question = question {
          self?.presentQuestion(question)
        } else {
          self?.presentScore()
        }
      }
      .store(in: &self.cancellables)

    self.setupConstraints()
  }

  private func setupConstraints() {
    self.pageController.view.translatesAutoresizingMaskIntoConstraints = false

    self.progressBar.constrain(to: self.view.layoutMarginsGuide, on: .trailing)
    self.progressBar.constrain(to: self.view.layoutMarginsGuide, on: .top, constant: 24.0)
    self.progressBar.constrain(to: 10.0, on: .height)
    self.pageController.view.constrain(to: self.view, on: [.horizontal, .bottom])

    self.closeButton.constrain(to: self.progressBar, on: .centerY)
    self.closeButton.constrain(to: self.view.layoutMarginsGuide, on: .leading)

    NSLayoutConstraint.activate([
      self.pageController.view.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor),
      self.progressBar.leadingAnchor.constraint(equalTo: self.closeButton.trailingAnchor, constant: 16)
    ])
  }

  private func presentQuestion(_ question: QuizQuestion) {
    let viewModel = QuizQuestionViewModel(for: question, with: self.viewModel.subject)
    let controller = QuizQuestionViewController(using: viewModel)

    self.pageController.setViewControllers([controller], direction: .forward, animated: true)
    self.progressBar.progress = self.viewModel.progress(for: question)
  }

  private func presentScore() {
    let viewModel = QuizCompleteViewModel(for: self.viewModel.questions)
    let completeVc = QuizCompleteViewController(using: viewModel)

    self.progressBar.isHidden = true

    self.pageController.setViewControllers([completeVc], direction: .forward, animated: true)
  }
}
