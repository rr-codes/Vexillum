//
//  Country.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Foundation

struct Country: Codable, Hashable {
  struct Name: Codable, Hashable {
    let common: String
    let official: String

    func contains(query: String) -> Bool {
      common.localizedCaseInsensitiveContains(query)
        || official.localizedCaseInsensitiveContains(query)
    }
  }

  struct Currency: Codable, Hashable {
    let name: String
    let symbol: String
  }

  let name: Name
  let tld: [String]
  let cca2: String
  let cca3: String
  let independent: Bool?
  let unMember: Bool?
  let currencies: [String: Currency]
  let capital: [String]
  let region: String
  let subregion: String?
  let languages: [String: String]
  let latlng: [Double]
  let borders: [String]
  let area: Double
  let flag: String
  let wiki: URL?
  let design: String?

  var areaMeasurement: Measurement<UnitArea> {
    Measurement(value: self.area, unit: UnitArea.squareKilometers)
  }

  var flagImageName: String {
    self.cca2.lowercased()
  }
}

extension Country: Comparable {
  static func < (lhs: Country, rhs: Country) -> Bool {
    lhs.name.common.localizedCompare(rhs.name.common) == .orderedAscending
  }
}

extension Country: Identifiable {
  // swiftlint:disable:next identifier_name
  var id: String {
    self.cca3
  }
}
