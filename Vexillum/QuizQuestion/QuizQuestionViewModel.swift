//
//  QuizQuestionViewModel.swift
//  QuizQuestionViewModel
//
//  Created by Richard Robinson on 2021-08-19.
//

import Foundation
import UIKit
import Combine

class QuizQuestionViewModel {
  private var question: QuizQuestion

  private let subject: PassthroughSubject<QuizQuestion.Option, Never>

  init(for question: QuizQuestion, with subject: PassthroughSubject<QuizQuestion.Option, Never>) {
    self.question = question
    self.subject = subject
  }

  func correctFlagImage() -> UIImage {
    UIImage(named: self.question.correctOption.flagImageName)!
  }

  func options() -> [QuizQuestion.Option] {
    self.question.allOptions
  }

  func submitAnswer(_ option: QuizQuestion.Option, _ completion: (Bool) -> Void) {
    self.question.answer = option
    completion(self.question.isCorrect)
    subject.send(option)
  }
}
