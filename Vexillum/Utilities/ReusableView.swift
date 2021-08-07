//
//  ReusableView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-04.
//

import Foundation
import UIKit

public protocol ReusableView {
  static var reuseIdentifier: String { get }
}

extension ReusableView {
  public static var reuseIdentifier: String {
    String(describing: self)
  }
}

// MARK: UITableView conformance to ReusableView

extension UITableView {
  public typealias ReusableCell = ReusableView & UITableViewCell
  public typealias ReusableHeaderFooter = ReusableView & UITableViewHeaderFooterView

  public func registerCell<Cell: ReusableCell>(_ cellClass: Cell.Type) {
    register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
  }

  public func registerHeaderFooterView<HeaderFooterView>(_ viewClass: HeaderFooterView.Type)
  where HeaderFooterView: ReusableHeaderFooter {
    register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.reuseIdentifier)
  }

  public func dequeueReusableCell<Cell: ReusableCell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell {
    dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! Cell
  }

  public func dequeueReusableHeaderFooterView<HeaderFooterView: ReusableHeaderFooter>(
    _ viewClass: HeaderFooterView.Type
  ) -> HeaderFooterView {
    dequeueReusableHeaderFooterView(withIdentifier: viewClass.reuseIdentifier) as! HeaderFooterView
  }
}
