//
//  BindableCell.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-10.
//

import Foundation
import UIKit

protocol BindableCell: UITableViewCell {
  func bind(to country: Country, for row: Int)
}
