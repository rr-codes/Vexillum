//
//  IntentViewController.swift
//  Flag of the Day Intent UI
//
//  Created by Richard Robinson on 2021-07-03.
//

import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
  private let imageView = UIImageView()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.imageView.contentMode = .scaleAspectFill
    self.imageView.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(self.imageView)

    self.imageView.constrain(to: self.view, on: .edges)
  }

  // MARK: - INUIHostedViewControlling

  private func getScaledSize(maxSize: CGSize, imageSize: CGSize) -> CGSize {
    let aspectRatio = imageSize.height / imageSize.width
    return CGSize(width: maxSize.width, height: maxSize.width * aspectRatio)
  }

  // Prepare your view controller for the interaction to handle.
  func configureView(
    for parameters: Set<INParameter>,
    of interaction: INInteraction,
    interactiveBehavior: INUIInteractiveBehavior,
    context: INUIHostedViewContext,
    completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void
  ) {
    guard
      let response = interaction.intentResponse as? FlagIntentResponse,
      let imageFile = response.flag?.image
    else {
      print("Unable to get intent response")
      completion(false, parameters, .zero)
      return
    }

    let image = UIImage(data: imageFile.data)!
    self.imageView.image = image

    let imageSize = self.imageView.image!.size
    let maxSize = self.extensionContext!.hostedViewMaximumAllowedSize

    let scaledSize = getScaledSize(maxSize: maxSize, imageSize: imageSize)

    completion(true, parameters, scaledSize)
  }
}
