//
//  UIView+Extended.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-04.
//

import Foundation
import UIKit

extension UIView {
    func pinEdges(to parent: UIView) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }
}
