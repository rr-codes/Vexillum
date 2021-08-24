//
//  QuizViewModel.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import Combine
import UIKit
import ConfettiView

class QuizViewModel: ObservableObject {
  var questions: [QuizQuestion]
  @Published var currentQuestion: QuizQuestion?

  let subject = PassthroughSubject<QuizQuestion.Option, Never>()

  private var cancellables = Set<AnyCancellable>()

  func progress(for question: QuizQuestion) -> CGFloat {
    let index = self.questions.firstIndex(of: question)!
    return CGFloat(index) / CGFloat(self.questions.count)
  }

  init(using provider: CountryProvider = .shared, numberOfQuestions: Int = 3, choicesPerQuestion: Int = 4) {
    self.questions = Self.createQuiz(
      for: provider.allCountries,
         numberOfQuestions: numberOfQuestions,
         choicesPerQuestion: choicesPerQuestion
    )

    self.currentQuestion = self.questions.first

    subject.sink { [weak self] in
      self?.questionWasAnswered(with: $0)
    }.store(in: &cancellables)
  }

  private static func convertCountryToOption(_ country: Country) -> QuizQuestion.Option {
    .init(id: country.id, flagImageName: country.flagImageName, name: country.name.common, flag: country.flag)
  }

  private static func createQuiz(
    for countries: [Country],
    numberOfQuestions: Int,
    choicesPerQuestion: Int
  ) -> [QuizQuestion] {
    let shuffled = countries.shuffled()

    let answers = shuffled.prefix(numberOfQuestions)

    let alternates = shuffled
      .dropFirst(numberOfQuestions)
      .chunked(into: choicesPerQuestion - 1)
      .prefix(numberOfQuestions)

    return zip(answers, alternates).map {
      QuizQuestion(
        correctOption: Self.convertCountryToOption($0),
        alternateOptions: $1.map(Self.convertCountryToOption(_:))
      )
    }
  }

  func questionWasAnswered(with option: QuizQuestion.Option) {
    let currentQuestion = self.currentQuestion!
    let index = self.questions.firstIndex(of: currentQuestion)!

    self.questions[index].answer = option

    self.currentQuestion = index == self.questions.indices.endIndex - 1 ? nil : self.questions[index + 1]
  }
}

extension Collection where Self.Index == Int {
  func chunked(into size: Self.Index) -> [[Element]] {
    stride(from: self.startIndex, to: self.endIndex, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, self.endIndex)])
    }
  }
}
