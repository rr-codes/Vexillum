//
//  FlagListViewModel.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Combine
import Foundation

class FlagListViewModel: ObservableObject {
  @Published var countries: [Country]

  private var countryProvider: CountryProvider

  init(countryProvider: CountryProvider = .shared) {
    self.countryProvider = countryProvider
    self.countries = countryProvider.allCountries
  }

  func country(id: Country.ID) -> Country {
    self.countryProvider.allCountries.first { $0.id == id }!
  }

  func filterCountries(by query: String?) {
    var filteredCountries = self.countryProvider.allCountries
    if let query = query, !query.isEmpty {
      filteredCountries = filteredCountries.filter {
        $0.name.contains(query: query)
      }
    }
    self.countries = filteredCountries
  }

  func randomCountry() -> Country {
    self.countryProvider.allCountries.randomElement()!
  }
}
