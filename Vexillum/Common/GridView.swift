//
//  GridView.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import UIKit

class GridView<Element, Cell: UIView>: UIView {
  init(_ elements: [Element], numberOfColumns columns: Int, spacing: CGFloat, provider: (Element) -> Cell) {
    super.init(frame: .zero)

    let outerStackView = UIStackView()
    outerStackView.axis = .vertical
    outerStackView.alignment = .fill
    outerStackView.distribution = .fillEqually
    outerStackView.spacing = spacing

    for column in 0..<(elements.count / columns) {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.alignment = .fill
      stackView.distribution = .fillEqually
      stackView.spacing = spacing

      for row in 0..<columns {
        let element = elements[(column * columns) + row]
        stackView.addArrangedSubview(provider(element))
      }

      outerStackView.addArrangedSubview(stackView)
    }

    outerStackView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(outerStackView)

    outerStackView.constrain(to: self, on: .edges)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
