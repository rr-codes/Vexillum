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
  private let questions: [QuizQuestion]
  private var answers: [QuizQuestion.Option] = []

  var currentQuestion: QuizQuestion? {
    didSet {
      self.onCurrentQuestionChanged?(self.currentQuestion == nil)
    }
  }

  var onCurrentQuestionChanged: ((Bool) -> Void)?

  init(using provider: CountryProvider = .shared, numberOfQuestions: Int = 20, choicesPerQuestion: Int = 4) {
    self.questions = Self.createQuiz(
      for: provider.allCountries,
         numberOfQuestions: numberOfQuestions,
         choicesPerQuestion: choicesPerQuestion
    )
    self.currentQuestion = self.questions.first!
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

  func addAnswer(_ answer: QuizQuestion.Option) {
    self.answers.append(answer)
  }

  func correctFlagImage() -> UIImage {
    UIImage(named: self.currentQuestion!.correctOption.flagImageName)!
  }

  func options() -> [QuizQuestion.Option] {
    self.currentQuestion!.allOptions
  }

  func isCorrect(selectedOption: QuizQuestion.Option) -> Bool {
    self.currentQuestion!.correctOption == selectedOption
  }

  func goToNextQuestion() {
    guard let currentQuestion = self.currentQuestion,
          let index = self.questions.firstIndex(of: currentQuestion)
    else {
      fatalError()
    }

    self.currentQuestion = index == self.questions.indices.endIndex - 1 ? nil : self.questions[index + 1]
  }

  func progress() -> CGFloat {
    let index = self.questions.firstIndex(of: self.currentQuestion!)!
    return CGFloat(index) / CGFloat(self.questions.count)
  }

  func percentCorrect() -> Double {
    let amountCorrect = self.correctOptions().count
    return Double(amountCorrect) / Double(self.questions.count)
  }

  func confettiContent() -> [ConfettiView.Content] {
    self.correctOptions().map { ConfettiView.Content.text($0.correctOption.flag, 14.0) }
  }

  private func correctOptions() -> [QuizQuestion] {
    zip(self.questions, self.answers).filter { $0.correctOption == $1 }.map(\.0)
  }
}

extension Collection where Self.Index == Int {
  func chunked(into size: Self.Index) -> [[Element]] {
    stride(from: self.startIndex, to: self.endIndex, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, self.endIndex)])
    }
  }
}
