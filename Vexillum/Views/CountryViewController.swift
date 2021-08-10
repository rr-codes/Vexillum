//
//  CountryViewController.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Foundation
import PreviewView
import SwiftUI
import UIKit

class CountryViewDetailCell: UITableViewCell, ReusableView {
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

  func bind(to cellDetail: CountryViewCellDetail) {
    self.textLabel?.text = cellDetail.label
    self.detailTextLabel?.text = cellDetail.value
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

struct CountryViewCellDetail {
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

class CountryViewController: UITableViewController {
  private let measurementFormatter = MeasurementFormatter()
  private let country: Country

  private var countryDetails: [CountryViewCellDetail] {
    [
      .init(label: "Official Name", value: country.name.official),
      .init(label: "Country Codes", value: "\(country.cca2), \(country.cca3)"),
      .init(label: "Capital", value: country.capital),
      .init(label: "Region", value: country.region),
      .init(label: "Land Area", value: measurementFormatter.string(from: country.areaMeasurement)),
      .init(label: "Currencies", value: country.currencies.map { "\($1.symbol) (\($0))" }),
      .init(label: "Languages", value: country.languages.values.sorted()),
    ]
  }

  init(
    country: Country
  ) {
    self.country = country
    super.init(style: .insetGrouped)
    self.configureNavigationItem()
  }

  @available(*, unavailable)
  required init?(
    coder _: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.registerCell(FlagListTableViewCell.self)
    self.tableView.registerCell(CountryViewDetailCell.self)
  }

  private func configureNavigationItem() {
    self.navigationItem.title = self.country.name.common
    self.navigationItem.largeTitleDisplayMode = .always
  }
}

extension CountryViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return self.countryDetails.count
    case 2:
      return 0
    default:
      fatalError()
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    44.0
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Flag"

    case 1:
      return "Details"

    case 2:
      return "Location"

    default:
      fatalError()
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(FlagListTableViewCell.self, for: indexPath)

      cell.bind(to: self.country)
      cell.layoutIfNeeded()

      return cell

    case 1:
      let cell = tableView.dequeueReusableCell(CountryViewDetailCell.self, for: indexPath)

      cell.bind(to: self.countryDetails[indexPath.item])
      cell.layoutIfNeeded()

      return cell

    default:
      fatalError()
    }
  }
}

struct CountryViewController_Previews: PreviewProvider {
  static var previews: some View {
    Preview(
      for: CountryViewController(country: CountryProvider.shared.countryOfTheDay(for: .init())),
      navigationControllerStyle: .wrap(prefersLargeTitles: true)
    )
    .edgesIgnoringSafeArea(.all).previewDevice(nil)
  }
}
