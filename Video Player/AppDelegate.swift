//
//  AppDelegate.swift
//  Video Player
//
//  Created by Skuerth on 2019/1/16.
//  Copyright © 2019 Skuerth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let viewConroller = ViewController()
        viewConroller.view.backgroundColor = UIColor(red: 8.0 / 255.0, green: 21.0 / 255.0, blue: 35.0 / 255.0, alpha: 1)

        window!.rootViewController = viewConroller
        window?.makeKeyAndVisible()

        return true
    }
}
