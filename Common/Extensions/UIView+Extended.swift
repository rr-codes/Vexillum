//
//  UIView+Extended.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-04.
//

import Foundation
import UIKit

protocol Anchorable {
  var leadingAnchor: NSLayoutXAxisAnchor { get }
  var trailingAnchor: NSLayoutXAxisAnchor { get }
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }
  var centerXAnchor: NSLayoutXAxisAnchor { get }
  var centerYAnchor: NSLayoutYAxisAnchor { get }
  var widthAnchor: NSLayoutDimension { get }
  var heightAnchor: NSLayoutDimension { get }
}

extension UIView: Anchorable {}
extension UILayoutGuide: Anchorable {}

extension NSLayoutConstraint {
  struct Anchor: OptionSet {
    let rawValue: Int

    static let leading    = Self(rawValue: 1 << 0)
    static let trailing   = Self(rawValue: 1 << 1)
    static let top        = Self(rawValue: 1 << 2)
    static let bottom     = Self(rawValue: 1 << 3)
    static let centerX    = Self(rawValue: 1 << 4)
    static let centerY    = Self(rawValue: 1 << 5)
    static let width      = Self(rawValue: 1 << 6)
    static let height     = Self(rawValue: 1 << 7)

    static let edges: Self = [.leading, .top, .trailing, .bottom]
    static let center: Self = [.centerX, .centerY]
    static let horizontal: Self = [.leading, .trailing]
    static let vertical: Self = [.top, .bottom]
  }

  struct Dimension: OptionSet {
    let rawValue: Int

    static let width    = Self(rawValue: 1 << 0)
    static let height   = Self(rawValue: 1 << 1)
  }
}

extension Anchorable {
  func constrain(to constant: CGFloat, on dimensions: NSLayoutConstraint.Dimension) {
    var constraints: [NSLayoutConstraint] = []

    if dimensions.contains(.width) {
      constraints.append(self.widthAnchor.constraint(equalToConstant: constant))
    }
    if dimensions.contains(.height) {
      constraints.append(self.heightAnchor.constraint(equalToConstant: constant))
    }

    NSLayoutConstraint.activate(constraints)
  }

  func constrain<Parent: Anchorable>(to parent: Parent, on anchors: NSLayoutConstraint.Anchor, constant: CGFloat = 0) {
    var constraints: [NSLayoutConstraint] = []

    if anchors.contains(.bottom) {
      constraints.append(self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -constant))
    }
    if anchors.contains(.top) {
      constraints.append(self.topAnchor.constraint(equalTo: parent.topAnchor, constant: constant))
    }
    if anchors.contains(.leading) {
      constraints.append(self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: constant))
    }
    if anchors.contains(.trailing) {
      constraints.append(self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -constant))
    }
    if anchors.contains(.centerX) {
      constraints.append(self.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: constant))
    }
    if anchors.contains(.centerY) {
      constraints.append(self.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: constant))
    }
    if anchors.contains(.width) {
      constraints.append(self.widthAnchor.constraint(equalTo: parent.widthAnchor, constant: constant))
    }
    if anchors.contains(.height) {
      constraints.append(self.heightAnchor.constraint(equalTo: parent.heightAnchor, constant: constant))
    }

    NSLayoutConstraint.activate(constraints)
  }
}
