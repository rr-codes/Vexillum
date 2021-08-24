//
//  QuizCompleteViewModel.swift
//  QuizCompleteViewModel
//
//  Created by Richard Robinson on 2021-08-19.
//

import Foundation
import ConfettiView

class QuizCompleteViewModel {
  private let questions: [QuizQuestion]

  init(for questions: [QuizQuestion]) {
    self.questions = questions
  }

  func percentCorrect() -> Double {
    let amountCorrect = self.questions.filter(\.isCorrect).count
    return Double(amountCorrect) / Double(self.questions.count)
  }

  func confettiContent() -> [ConfettiView.Content] {
    self.questions
      .filter(\.isCorrect)
      .map { ConfettiView.Content.text($0.correctOption.flag, 14.0) }
  }
}
