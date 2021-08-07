//
//  FlagListView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Combine
import Foundation
import PreviewView
import SwiftUI
import UIKit

class FlagListViewController: UITableViewController {
  private let viewModel = FlagListViewModel()
  private let searchController = UISearchController(searchResultsController: nil)
  private var cancellables = Set<AnyCancellable>()

  private lazy var dataSource: FlagListDataSource = {
    let source = FlagListDataSource(tableView: self.tableView, cellProvider: self.cellProvider)
    source.viewModel = self.viewModel
    return source
  }()

  init() {
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

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.registerCell(FlagListTableViewCell.self)
    self.searchController.obscuresBackgroundDuringPresentation = false
    self.searchController.searchResultsUpdater = self

    self.onCountriesChange(newValue: self.viewModel.countries)

    self.viewModel.$countries
      .sink { [weak self] in self?.onCountriesChange(newValue: $0) }
      .store(in: &self.cancellables)
  }

  private func configureNavigationItem() {
    self.navigationItem.title = "Vexillum"
    self.navigationItem.largeTitleDisplayMode = .always
    self.navigationItem.searchController = self.searchController

    self.navigationItem.rightBarButtonItems = [
      UIBarButtonItem(
        image: UIImage(named: "dice"),
        style: .plain,
        target: self,
        action: #selector(self.onRandomCountryButtonTap)
      )
    ]
  }

  private func cellProvider(tableView: UITableView, indexPath: IndexPath, countryId: Country.ID) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(FlagListTableViewCell.self, for: indexPath)
    let country = self.viewModel.country(id: countryId)

    cell.bind(to: country)

    return cell
  }

  @objc private func onRandomCountryButtonTap() {

  }

  private func onCountriesChange(newValue: [Country]) {
    let ids = newValue.map(\.id)

    var snapshot = NSDiffableDataSourceSnapshot<Country.ID, Country.ID>()
    snapshot.appendSections(ids)

    for item in ids {
      snapshot.appendItems([item], toSection: item)
    }

    self.dataSource.apply(snapshot, animatingDifferences: false)
  }
}

// MARK: UITableViewDataSource

class FlagListDataSource: UITableViewDiffableDataSource<Country.ID, Country.ID> {
  var viewModel: FlagListViewModel!

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let id = self.snapshot().sectionIdentifiers[section]
    let country = self.viewModel.country(id: id)
    return country.name.common
  }
}

// MARK: UITableViewDelegate

extension FlagListViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
}

// MARK: UISearchResultsUpdating

extension FlagListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    self.viewModel.filterCountries(by: searchController.searchBar.text)
  }
}

struct YourViewController_Previews: PreviewProvider {
  static var previews: some View {
    Preview(
      for: FlagListViewController(),
      navigationControllerStyle: .wrap(prefersLargeTitles: true)
    )
    .edgesIgnoringSafeArea(.all).previewDevice(nil)
  }
}
