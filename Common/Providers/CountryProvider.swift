//
//  CountryProvider.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Foundation
import UIKit
import CoreSpotlight
import MobileCoreServices

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

  private func createSearchableItem(for country: Country) -> CSSearchableItem {
    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeImage as String)

    attributeSet.title = "Flag of \(country.name.common)"
    attributeSet.contentDescription = "The flag of \(country.name.official)"
    attributeSet.thumbnailData = UIImage(named: country.flagImageName)!.pngData()!
    attributeSet.keywords = [country.cca3, country.name.common, "flag", "country"]

    return CSSearchableItem(
      uniqueIdentifier: country.id,
      domainIdentifier: "com.richardrobinson.vexillum",
      attributeSet: attributeSet
    )
  }

  func indexAllCountries() {
    let items = self.allCountries.map(self.createSearchableItem(for:))

    CSSearchableIndex.default().indexSearchableItems(items) { error in
      if let error = error {
        fatalError(error.localizedDescription)
      }
    }
  }
}
