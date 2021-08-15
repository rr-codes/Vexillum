//
//  Applyable.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation

protocol Applyable {}
extension Applyable {
    @discardableResult @inlinable func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Applyable {}
