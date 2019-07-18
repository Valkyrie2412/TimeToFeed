//
//  AppDelegate.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/16/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import Contacts




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

//    var tabbarCustom: TabbarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
//                    let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
//                    tabbarCustom = mainStoryboard.instantiateViewController(withIdentifier: "TabViewController") as? TabbarController
//                    UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
//                        self.window?.rootViewController = self.tabbarCustom
//                    }, completion: { completed in
//                        // maybe do something here
//                    })
//                    window!.makeKeyAndVisible()
        
        
        FirebaseApp.configure()
        ApplicationDelegate
            .shared
            .application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if AccessToken.current == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = UINavigationController(rootViewController:  ScreenViewController(nibName: "ScreenViewController", bundle: nil))
            window?.makeKeyAndVisible()
            
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let screenTab = sb.instantiateViewController(withIdentifier: "TabViewController") as! TabbarController
            window?.rootViewController = screenTab
            window?.makeKeyAndVisible()
        }
        
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
            print("Access: \(access)")
        }
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        return handled
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

