//
//  AppDelegate.swift
//  TokopediaMiniProject
//
//  Created by Nakama on 06/11/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = SaveViewController()
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        self.window!.rootViewController = mainNavigationController
        self.window!.makeKeyAndVisible()
        return true
    }

}

