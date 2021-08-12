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

class CountryViewController: UITableViewController {
  private let country: Country

  init(country: Country) {
    self.country = country
    super.init(style: .insetGrouped)
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
    self.tableView.registerCell(CountryViewDetailCell.self)
    self.tableView.registerCell(CountryLocationCell.self)

    self.tableView.registerHeaderFooterView(LinkFooterView.self)
    self.tableView.registerHeaderFooterView(SectionSymbolHeaderView.self)
  }

  private func configureNavigationItem() {
    self.navigationItem.title = self.country.name.common
    self.navigationItem.largeTitleDisplayMode = .always
  }
}

// MARK: UITableViewDataSource + UITableViewDelegate

extension CountryViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Section(rawValue: section) else {
      fatalError()
    }

    return section.numberOfRows(for: self.country)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    44.0
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let section = Section(rawValue: section) else {
      fatalError()
    }

    let view = tableView.dequeueReusableHeaderFooterView(SectionSymbolHeaderView.self)
    view.bind(to: section, for: self.country)
    view.layoutIfNeeded()

    return view
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard let section = Section(rawValue: section) else {
      fatalError()
    }

    guard section != .details else {
      return nil
    }

    return section.footer(for: self.country)
  }

  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard Section(rawValue: section) == .details, let wiki = self.country.wiki else {
      return nil
    }

    let text = Section.details.footer(for: self.country)!

    let view = tableView.dequeueReusableHeaderFooterView(LinkFooterView.self)
    view.bind(to: text, link: wiki)
    view.layoutIfNeeded()

    return view
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      fatalError()
    }

    let cell = section.dequeueCell(tableView, cellForRowAt: indexPath)
    cell.bind(to: self.country, for: indexPath.item)
    cell.layoutIfNeeded()

    return cell
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
