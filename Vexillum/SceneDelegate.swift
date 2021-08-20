//
//  SceneDelegate.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-03.
//

import UIKit
import CoreSpotlight

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene
    // `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new
    // (see `application:configurationForConnectingSceneSession` instead).
    guard let scene = (scene as? UIWindowScene) else { return }

    let quizVc = QuizHomeViewController().apply {
      $0.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "gamecontroller"), tag: 0)
      $0.tabBarItem.selectedImage = UIImage(systemName: "gamecontroller.fill")
    }

    let flagListVc = FlagListViewController().apply {
      $0.tabBarItem = UITabBarItem(title: "Flags", image: UIImage(systemName: "flag"), tag: 1)
      $0.tabBarItem.selectedImage = UIImage(systemName: "flag.fill")
    }

    let quizViewNavigationController = UINavigationController(rootViewController: quizVc)
    let mainViewNavigationController = UINavigationController(rootViewController: flagListVc)

    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [mainViewNavigationController, quizViewNavigationController]

    let window = UIWindow(windowScene: scene)
    window.rootViewController = tabBarController

    self.window = window
    window.makeKeyAndVisible()

    let alreadyIndexed = UserDefaults.standard.bool(forKey: "isSpotlightIndexed")
    if !alreadyIndexed {
      CountryProvider.shared.indexAllCountries()
      UserDefaults.standard.set(true, forKey: "isSpotlightIndexed")
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded
    // (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }

  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    switch userActivity.activityType {
    case CSSearchableItemActionType:
      self.handleSearchableItemAction(from: userActivity)

    case "GetFlagIntent", "FlagOfTheDayIntent":
      self.handleFlagIntentAction(from: userActivity)

    default:
      fatalError("Invalid activity type: \(userActivity.activityType)")
    }
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for context in URLContexts where context.url.scheme == "com.richardrobinson.vexillum" {
      let countryId = context.url.lastPathComponent
      self.openCountryView(forCountryWithId: countryId)
    }
  }

  private func handleFlagIntentAction(from userActivity: NSUserActivity) {
    guard let countryId = userActivity.userInfo?["countryId"] as? String else {
      return
    }

    self.openCountryView(forCountryWithId: countryId)
  }

  private func handleSearchableItemAction(from userActivity: NSUserActivity) {
    guard let countryId = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
      return
    }

    self.openCountryView(forCountryWithId: countryId)
  }

  // swiftlint:disable identifier_name
  private func openCountryView(forCountryWithId id: Country.ID) {
    guard let window = self.window?.rootViewController as? UINavigationController else {
      fatalError()
    }

    let country = CountryProvider.shared.find(countryWithId: id)

    let countryViewController = CountryViewController(country: country)

    window.popToRootViewController(animated: false)
    window.pushViewController(countryViewController, animated: true)
  }
}
