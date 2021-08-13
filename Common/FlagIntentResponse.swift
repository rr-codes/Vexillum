//
//  FlagIntentResponse.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-13.
//

import Foundation
import Intents

protocol FlagIntentResponse {
  var flag: FlagData? { get }
}

extension FlagOfTheDayIntentResponse: FlagIntentResponse {}

extension GetFlagIntentResponse: FlagIntentResponse {}
