//
//  CountryViewDetailCell.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-10.
//

import Foundation
import UIKit

class CountryViewDetailCell: UITableViewCell, BindableCell, ReusableView {
  struct CellRow {
    let label: String
    let value: String

    init(
      label: String,
      value: String
    ) {
      self.label = label
      self.value = value
    }

    init<S: Sequence>(
      label: String,
      value: S
    ) where S.Element == String {
      self.init(label: label, value: value.joined(separator: ", "))
    }
  }

  private static let measurementFormatter = MeasurementFormatter()

  private static func getDetails(for country: Country) -> [CellRow] {
    return [
      .init(label: "Official Name", value: country.name.official),
      .init(label: "Country Codes", value: "\(country.cca2), \(country.cca3)"),
      .init(label: "Capital", value: country.capital),
      .init(label: "Region", value: country.region),
      .init(label: "Land Area", value: Self.measurementFormatter.string(from: country.areaMeasurement)),
      .init(label: "Currencies", value: country.currencies.map { "\($1.symbol) (\($0))" }),
      .init(label: "Languages", value: country.languages.values.sorted()),
    ]
  }

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.detailTextLabel!.lineBreakMode = .byWordWrapping
    self.detailTextLabel!.numberOfLines = 0
  }

  @available(*, unavailable)
  required init?(
    coder _: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(to country: Country, for row: Int) {
    let details = Self.getDetails(for: country)

    self.textLabel?.text = details[row].label
    self.detailTextLabel?.text = details[row].value
  }

  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    self.layoutIfNeeded()
    var size = super
      .systemLayoutSizeFitting(
        targetSize,
        withHorizontalFittingPriority: horizontalFittingPriority,
        verticalFittingPriority: verticalFittingPriority
      )

    size.height += detailTextLabel!.frame.size.height - textLabel!.frame.size.height

    return size
  }
}
