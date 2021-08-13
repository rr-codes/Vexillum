//
//  IntentHandler.swift
//  FlagOfTheDayIntent
//
//  Created by Richard Robinson on 2021-08-12.
//

import Intents
import UIKit
import MobileCoreServices

class IntentHandler: INExtension {

  override func handler(for intent: INIntent) -> Any {
    switch intent {
    case is FlagOfTheDayIntent:
      return FlagOfTheDayIntentHandler()

    case is GetFlagIntent:
      return GetFlagIntentHandler()

    default:
      fatalError()
    }
  }
}
