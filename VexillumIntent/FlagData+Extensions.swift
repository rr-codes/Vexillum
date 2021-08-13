//
//  FlagData+Extensions.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-13.
//

import Foundation
import UIKit
import CoreServices
import Intents

extension FlagData {
  convenience init(for country: Country) {
    let data = UIImage(named: country.flagImageName)!.pngData()!

    self.init(identifier: country.id, display: country.name.common)

    self.countryName = country.name.common
    self.image = INFile(
        data: data,
        filename: "\(country.flagImageName).png",
        typeIdentifier: kUTTypeImage as String
    )
  }
}
