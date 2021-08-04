//
//  FlagListViewModel.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import Foundation
import Combine

class FlagListViewModel: ObservableObject {
    @Published var activeCountry: Country? = nil
    @Published var countries: [Country] = []
    @Published var isShuffled: Bool = false
    @Published var filterText: String? = nil
    
    func filter(by query: String) -> [Country] {
        let queryLowercased = query.lowercased()
        return self.countries.filter {
            $0.name.common.lowercased().contains(queryLowercased) || $0.name.official.lowercased().contains(queryLowercased)
        }
    }
    
    func sort() {
        self.countries.sort()
        self.isShuffled = false
    }
    
    func shuffle() {
        self.countries.shuffle()
        self.isShuffled = true
    }
    
    func find(by id: Country.ID) -> Country {
        self.countries.first { $0.id == id }!
    }
}
