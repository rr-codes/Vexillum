//
//  Quiz.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation

struct Quiz {
  struct Question: Equatable, Identifiable {
    let id = UUID()

    let country: Country
    let alternateCountries: [Country]

    var allOptions: [Country] {
      (self.alternateCountries + [country]).shuffled()
    }

    static func == (_ lhs: Self, _ rhs: Self) -> Bool {
      lhs.id == rhs.id
    }
  }

  let questions: [Question]
}
