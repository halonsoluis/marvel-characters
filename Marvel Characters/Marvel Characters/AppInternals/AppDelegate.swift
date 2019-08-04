//
//  AppDelegate.swift
//  Marvel Characters
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        removeAllBackButtonTitles(application)
        return true
    }
    
    
    func removeAllBackButtonTitles(_ application : UIApplication) {
        let barAppearace = UIBarButtonItem.appearance()
        barAppearace.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -60), for:UIBarMetrics.default)
    }
}

