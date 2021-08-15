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
  var viewModel: QuizViewModel!
  private var cancellables = Set<AnyCancellable>()

  var pageController: UIPageViewController!

  private let progressBar = LinearProgressView().apply {
    $0.cornerRadius = 4.0
    $0.color = .systemIndigo
    $0.backgroundColor = .systemGray5
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private func updateCurrentViewController(index: Int) {
    let questionVc = QuizQuestionViewController().apply {
      $0.viewModel = self.viewModel
      $0.questionIndex = index
    }

    self.pageController.setViewControllers([questionVc], direction: .forward, animated: true)
    self.progressBar.progress = CGFloat(index) / CGFloat(self.viewModel.quiz.questions.count)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.pageController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )
    self.pageController.delegate = self

    self.view.addSubview(self.progressBar)

    self.addChild(self.pageController)
    self.view.addSubview(self.pageController.view)

    self.view.backgroundColor = .systemBackground

    self.updateCurrentViewController(index: 0)

    self.viewModel.$currentQuestionIndex
      .sink { [weak self] in self?.updateCurrentViewController(index: $0) }
      .store(in: &self.cancellables)

    self.pageController.view.translatesAutoresizingMaskIntoConstraints = false

    self.progressBar.constrain(to: self.view.layoutMarginsGuide, on: [.top, .horizontal])
    self.progressBar.constrain(to: 8.0, on: .height)
    self.pageController.view.constrain(to: self.view, on: [.horizontal, .bottom])

    NSLayoutConstraint.activate([
      self.pageController.view.topAnchor.constraint(equalTo: self.progressBar.bottomAnchor)
    ])
  }
}

extension QuizViewController: UIPageViewControllerDelegate {

}
