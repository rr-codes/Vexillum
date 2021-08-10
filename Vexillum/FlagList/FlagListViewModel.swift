//
//  FlagListViewModel.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Combine
import Foundation

class FlagListViewModel: ObservableObject {
  private var countryProvider: CountryProvider

  @Published var filterQuery: String? = nil

  var countries: [Country] {
    let allCountries = self.countryProvider.allCountries

    guard let query = self.filterQuery, !query.isEmpty else {
      return allCountries
    }

    return allCountries.filter { $0.name.contains(query: query) }
  }

  init(
    countryProvider: CountryProvider = .shared
  ) {
    self.countryProvider = countryProvider
  }

  func randomCountry() -> Country {
    self.countryProvider.allCountries.randomElement()!
  }
}
