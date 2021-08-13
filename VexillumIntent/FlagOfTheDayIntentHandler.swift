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
    let userActivity = NSUserActivity(activityType: String(describing: FlagOfTheDayIntent.self))

    let country = self.countryProvider.countryOfTheDay(for: Date())

    userActivity.userInfo = ["countryId": country.id]
    let successResponse = FlagOfTheDayIntentResponse(code: .success, userActivity: userActivity)
    successResponse.flag = FlagData(for: country)

    completion(successResponse)
  }
}
