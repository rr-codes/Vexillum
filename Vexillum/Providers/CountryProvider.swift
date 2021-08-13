//
//  CountryProvider.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Foundation
import UIKit

class CountryProvider {
  static let shared = CountryProvider()

  let allCountries: [Country]

  private init() {
    guard let asset = NSDataAsset(name: "countries") else {
      fatalError("Missing data asset: countries")
    }

    let decoded = try? JSONDecoder().decode([Country].self, from: asset.data)
    self.allCountries = decoded?.sorted() ?? []
  }

  // swiftlint:disable identifier_name
  func find(countryWithId id: Country.ID) -> Country {
    self.allCountries.first { $0.id == id }!
  }

  func countryOfTheDay(for date: Date) -> Country {
    let today = Calendar.current.ordinality(of: .day, in: .year, for: date)!
    var rng = SplitMix64(seed: UInt64(today))

    let shuffled = self.allCountries.shuffled(using: &rng)
    return shuffled[today % self.allCountries.count]
  }
}
