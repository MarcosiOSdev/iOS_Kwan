//
//  AppDelegate.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 23/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupRootViewController()
        return true
    }
    
    private func setupRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = HomeViewController.loadFromNib()
        self.window?.makeKeyAndVisible()
    }
}


