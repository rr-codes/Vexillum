//
//  Quiz.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation

struct QuizQuestion: Equatable {
  struct Option: Equatable, Identifiable {
    let id: Country.ID
    let flagImageName: String
    let name: String
    let flag: String
  }

  let correctOption: Option
  let alternateOptions: [Option]

  var allOptions: [Option] {
    (self.alternateOptions + [self.correctOption]).shuffled()
  }
}
