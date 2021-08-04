//
//  FlagListView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Foundation
import UIKit
import SwiftUI
import PreviewView

extension UIView {
    func constrain(to parent: UIView) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: parent.leftAnchor),
            self.rightAnchor.constraint(equalTo: parent.rightAnchor),
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])
    }
}

class FlagListTableViewCell: UITableViewCell {
    static let reuseIdentifier = "flagListTableViewCell"
    
    private let flagImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.flagImageView.contentMode = .scaleAspectFit
        self.flagImageView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.flagImageView)
        
        self.flagImageView.constrain(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(to country: Country) {
        let image = UIImage(named: country.flagImageName)!
        self.flagImageView.image = image
    }
}

extension FlagListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.filteredCountries[section].name.common
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = self.filteredCountries[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FlagListTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! FlagListTableViewCell
                
        cell.bind(to: country)
                
        return cell
    }
}

extension FlagListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.filteredCountries[indexPath.section]
    }
}

extension FlagListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.filterText = searchController.searchBar.text
        (self.view as! UITableView).reloadData()
    }
}

class FlagListViewController: UIViewController {
    private var filteredCountries: [Country] {
        if let filterText = self.viewModel.filterText, !filterText.isEmpty {
            return self.viewModel.filter(by: filterText)
        } else {
            return self.viewModel.countries
        }
    }
    
    private let viewModel = FlagListViewModel()
    
    override func loadView() {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FlagListTableViewCell.self, forCellReuseIdentifier: FlagListTableViewCell.reuseIdentifier)
        
        self.view = tableView
        
        self.navigationItem.title = "Vexillum"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController!.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.countries = CountryProvider.shared.allCountries
        (self.view as! UITableView).reloadData()
    }
}

struct YourViewController_Previews: PreviewProvider {
    static var previews: some View {
        Preview(for: FlagListViewController(), navigationControllerStyle: .wrap(prefersLargeTitles: true))
            .edgesIgnoringSafeArea(.all)
            .previewDevice(nil)
    }
}
