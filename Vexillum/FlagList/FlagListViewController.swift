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

  private var visibleCountries: [Country] = []

  init() {
    super.init(style: .insetGrouped)

    self.visibleCountries = self.viewModel.countries
    self.configureNavigationItem()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
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
    self.tableView.rowHeight = UITableView.automaticDimension

    self.searchController.obscuresBackgroundDuringPresentation = false
    self.searchController.searchResultsUpdater = self

    self.viewModel.$filterQuery
      .sink { [weak self] _ in
        guard let self = self else {
          return
        }

        self.visibleCountries = self.viewModel.countries
        self.tableView.reloadData()
      }
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

  @objc private func onRandomCountryButtonTap() {

  }
}

// MARK: UITableViewDataSource

extension FlagListViewController {
  public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    self.visibleCountries[section].name.common
  }

  public override func numberOfSections(in tableView: UITableView) -> Int {
    self.visibleCountries.count
  }

  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(FlagListTableViewCell.self, for: indexPath)
    let country = self.visibleCountries[indexPath.section]

    cell.bind(to: country, for: indexPath.item)
    cell.layoutIfNeeded()

    return cell
  }
}

// MARK: UITableViewDelegate

extension FlagListViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let country = self.visibleCountries[indexPath.section]
    let countryViewController = CountryViewController(country: country)
    self.navigationController!.pushViewController(countryViewController, animated: true)
  }
}

// MARK: UISearchResultsUpdating

extension FlagListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    self.viewModel.filterQuery = searchController.searchBar.text
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
