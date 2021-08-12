//
//  Sections.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-10.
//

import Foundation
import UIKit

extension CountryViewController {
  enum Section: Int, CaseIterable {
    case flag, details, location

    func numberOfRows(for country: Country) -> Int {
      switch self {
      case .flag: return 1
      case .details: return 7
      case .location: return 0
      }
    }

    func header(for country: Country) -> (text: String, symbolName: String) {
      switch self {
      case .flag: return (text: "Flag", symbolName: "flag")
      case .details: return (text: "Details", symbolName: "info.circle")
      case .location: return (text: "Location", symbolName: "map")
      }
    }

    func footer(for country: Country) -> String? {
      switch self {
      case .flag: return country.design
      case .details: return "More at Wikipedia"
      case .location: return nil
      }
    }

    func dequeueCell(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> BindableCell & UITableView.ReusableCell {
      switch self {
      case .flag: return tableView.dequeueReusableCell(FlagListTableViewCell.self, for: indexPath)
      case .details: return tableView.dequeueReusableCell(CountryViewDetailCell.self, for: indexPath)
      case .location: fatalError()
      }
    }
  }
}
