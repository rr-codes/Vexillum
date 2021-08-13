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

class FlagOfTheDayIntentHandler: NSObject, FlagOfTheDayIntentHandling {
  private let countryProvider = CountryProvider.shared

  func handle(intent: FlagOfTheDayIntent, completion: @escaping (FlagOfTheDayIntentResponse) -> Void) {
    let country = self.countryProvider.countryOfTheDay(for: Date())
    let flagData = FlagData(for: country)

    completion(.success(flag: flagData))
  }
}
