//
//  AppDelegate.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        let tabBarController = self.window?.rootViewController as! UITabBarController   
        // User is logged in, adjust tabBar.item[2] accordingly with profile VC
        if Auth().token != nil {
            tabBarController.tabBar.items?[3].title = "Profile"
            let profileTableVC = storyboard.instantiateViewController(withIdentifier: "ProfileTableViewController") as! UITableViewController
            let navigationController = tabBarController.viewControllers?[3] as! UINavigationController
            navigationController.pushViewController(profileTableVC, animated: false)
        // User is not logged in
        } else {
            tabBarController.tabBar.items?[3].title = "Log in"
        }
        
        return true
    }



}

