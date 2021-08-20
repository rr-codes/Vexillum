//
//  QuizHomeViewController.swift
//  QuizHomeViewController
//
//  Created by Richard Robinson on 2021-08-15.
//

import Foundation
import UIKit

class QuizHomeViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let button = UIButton()
    button.setTitle("Click me", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false

    self.view.backgroundColor = .systemBackground

    self.view.addSubview(button)

    button.constrain(to: self.view, on: .center)
    button.constrain(to: 100, on: [.width, .height])

    self.modalPresentationStyle = .pageSheet
  }

  @objc private func buttonAction(_ sender: UIButton) {
    self.present(QuizViewController(), animated: true) {
      print("bye")
    }
  }
}
