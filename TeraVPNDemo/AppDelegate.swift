//
//  AppDelegate.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 16/09/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LanguageManager_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        // Set the default language for the app
        LanguageManager.shared.defaultLanguage = .en
        LanguageManager.shared.setLanguage(language: .en)
        
        let selectedLanguage = UserDefaults.standard.value(forKey: User_Defaults.selectedLanguage) as? String
        
        if selectedLanguage == Languages.en.rawValue{
            LanguageManager.shared.setLanguage(language: .en)
        }
        else if selectedLanguage == Languages.es.rawValue{
            LanguageManager.shared.setLanguage(language: .es)
        }
        
        
        IQKeyboardManager.shared.enable = true
        
        UINavigationBar.appearance().barTintColor = UIColor.themeBlue
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        
        UserDefaults.standard.removeObject(forKey: User_Defaults.selectIp)
//        let navigationBarAppearace = UINavigationBar.appearance()

//        navigationBarAppearace.tintColor = UIColor(hexString: "#0ffffff")
//        navigationBarAppearace.barTintColor = UIColor(hexString: "#2B1468")
//        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOSApplicationExtension 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOSApplicationExtension 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

