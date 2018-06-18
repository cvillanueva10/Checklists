//
//  AppDelegate.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/11/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let dataModel = DataModel()
    var window: UIWindow?

    func saveData() {
        dataModel.saveChecklists()
    }
    
    // Function called when notification received while app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification: \(notification)")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.init(red: 0, green: 107/255, blue: 180/255, alpha: 1)
        let rootViewController = AllListsViewController()
        rootViewController.dataModel = dataModel
        let navigationController = UINavigationController(rootViewController:
            rootViewController)
        window?.rootViewController = navigationController
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }


}

