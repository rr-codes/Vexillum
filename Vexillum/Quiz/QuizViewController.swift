//
//  QuizViewController.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import UIKit
import Combine

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

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.addSubview(self.progressBar)

    self.addChild(self.pageController)
    self.view.addSubview(self.pageController.view)

    self.view.backgroundColor = .systemBackground

    if let currentQuestion = self.viewModel.currentQuestion {
      self.updateCurrentViewController(isQuizComplete: false)
    }
//
//    self.viewModel.$currentQuestion
//      .sink { [weak self] in
//        print(self?.viewModel.currentQuestion)
//        print($0)
//        self?.updateCurrentViewController(for: $0)
//      }
//      .store(in: &self.cancellables)

    self.viewModel.onCurrentQuestionChanged = self.updateCurrentViewController(isQuizComplete:)

    self.setupConstraints()
  }

  private func setupConstraints() {
    self.pageController.view.translatesAutoresizingMaskIntoConstraints = false

    self.progressBar.constrain(to: self.view.layoutMarginsGuide, on: [.top, .horizontal])
    self.progressBar.constrain(to: 8.0, on: .height)
    self.pageController.view.constrain(to: self.view, on: [.horizontal, .bottom])

    NSLayoutConstraint.activate([
      self.pageController.view.topAnchor.constraint(equalTo: self.progressBar.bottomAnchor)
    ])
  }

  private func updateCurrentViewController(isQuizComplete: Bool) {
    guard !isQuizComplete else {
      let completeVc = QuizCompleteViewController(using: self.viewModel)
      self.pageController.setViewControllers([completeVc], direction: .forward, animated: true)
      return
    }

    let questionVc = QuizQuestionViewController(using: self.viewModel)

    self.pageController.setViewControllers([questionVc], direction: .forward, animated: true)
    self.progressBar.progress = self.viewModel.progress()
  }
}
