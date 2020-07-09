//
//  AppDelegate.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

       func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
       ) -> Bool {

           self.window = UIWindow(frame: UIScreen.main.bounds)

           if let window = self.window {
               let navigationController = UINavigationController()
               navigationController.viewControllers = [StartViewController()]
               window.rootViewController = navigationController
               window.makeKeyAndVisible()
           }
           return true
       }
}

