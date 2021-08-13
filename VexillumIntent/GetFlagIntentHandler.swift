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
    guard let countryName = intent.country else {
      completion(.needsValue())
      return
    }

    let matchingCountryNames = self.countryProvider.allCountries
      .filter { $0.name.contains(query: countryName) }
      .map(\.name.common)

    switch matchingCountryNames.count {
    case 0: completion(.needsValue())
    case 1: completion(.success(with: matchingCountryNames.first!))
    default: completion(.disambiguation(with: matchingCountryNames))
    }
  }

  func handle(intent: GetFlagIntent, completion: @escaping (GetFlagIntentResponse) -> Void) {
    let userActivity = NSUserActivity(activityType: String(describing: GetFlagIntent.self))
    let failedResponse = GetFlagIntentResponse(code: .failure, userActivity: userActivity)

    guard let countryName = intent.country else {
      completion(failedResponse)
      return
    }

    let country = self.countryProvider.allCountries.first {
      $0.name.contains(query: countryName)
    }

    guard let country = country else {
      completion(failedResponse)
      return
    }

    userActivity.userInfo = ["countryId": country.id]
    let successResponse = GetFlagIntentResponse(code: .success, userActivity: userActivity)
    successResponse.flag = FlagData(for: country)

    completion(successResponse)
  }
}
