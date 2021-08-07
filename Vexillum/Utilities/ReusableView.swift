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

public extension ReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

// MARK: UITableView conformance to ReusableView

public extension UITableView {
    typealias ReusableCell = ReusableView & UITableViewCell
    typealias ReusableHeaderFooter = ReusableView & UITableViewHeaderFooterView

    func registerCell<Cell>(_ cellClass: Cell.Type) where Cell: ReusableCell {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func registerHeaderFooterView<HeaderFooterView>(
        _ viewClass: HeaderFooterView.Type
    ) where HeaderFooterView: ReusableHeaderFooter {
        register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.reuseIdentifier)
    }

    func dequeueReusableCell<Cell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: ReusableCell {
        // swiftlint:disable:next force_cast
        dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! Cell
    }

    func dequeueReusableHeaderFooterView<HeaderFooterView>(
        _ viewClass: HeaderFooterView.Type
    ) -> HeaderFooterView where HeaderFooterView: ReusableHeaderFooter {
        // swiftlint:disable:next force_cast
        dequeueReusableHeaderFooterView(withIdentifier: viewClass.reuseIdentifier) as! HeaderFooterView
    }
}
