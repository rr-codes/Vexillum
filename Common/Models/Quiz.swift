//
//  Quiz.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation

struct QuizQuestion {
  let id = UUID()

  struct Option {
    let id: Country.ID
    let flagImageName: String
    let name: String
    let flag: String
  }

  let correctOption: Option
  let alternateOptions: [Option]
  var answer: Option?

  var allOptions: [Option] {
    (self.alternateOptions + [self.correctOption]).shuffled()
  }

  var isCorrect: Bool {
    self.correctOption.id == self.answer?.id
  }
}

extension QuizQuestion: Equatable {
  static func == (_ lhs: Self, _ rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}
