//
//  FlagOfTheDayIntentHandler.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-12.
//

import Foundation
import UIKit
import Intents
import CoreServices

class GetFlagIntentHandler: NSObject, GetFlagIntentHandling {
  private let countryProvider = CountryProvider.shared

  func resolveCountry(for intent: GetFlagIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
    if let countryName = intent.country {
      completion(.success(with: countryName))
    } else {
      completion(.needsValue())
    }
  }

  func handle(intent: GetFlagIntent, completion: @escaping (GetFlagIntentResponse) -> Void) {
    guard let countryName = intent.country else {
      completion(GetFlagIntentResponse(code: .failure, userActivity: nil))
      return
    }

    let country = self.countryProvider.allCountries.first {
      $0.name.contains(query: countryName)
    }

    guard let country = country else {
      completion(GetFlagIntentResponse(code: .failure, userActivity: nil))
      return
    }

    completion(.success(flag: FlagData(for: country)))
  }
}
