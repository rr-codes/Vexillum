//
//  QuizViewModel.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import Combine

class QuizViewModel: ObservableObject {
  let quiz: Quiz

  @Published var currentQuestionIndex: Int = 0

  init(using provider: CountryProvider) {
    self.quiz = Self.createQuiz(for: provider.allCountries, numberOfQuestions: 20, choicesPerQuestion: 4)
  }

  private static func createQuiz(for countries: [Country], numberOfQuestions: Int, choicesPerQuestion: Int) -> Quiz {
    let shuffled = countries.shuffled()

    let answers = shuffled.prefix(numberOfQuestions)
    let alternates = shuffled
      .dropFirst(numberOfQuestions)
      .chunked(into: choicesPerQuestion - 1)
      .prefix(numberOfQuestions)

    let questions =  zip(answers, alternates).map { Quiz.Question(country: $0, alternateCountries: $1) }
    return Quiz(questions: questions)
  }
}

extension Collection where Self.Index == Int {
  func chunked(into size: Self.Index) -> [[Element]] {
    stride(from: self.startIndex, to: self.endIndex, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, self.endIndex)])
    }
  }
}
