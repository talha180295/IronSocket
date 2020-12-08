//
//  SettingsViewController.swift
//  TeraVPNDemo
//
//  Created by talha on 20/10/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        //let userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)
        
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    func setUpNavBar(){

//        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
//
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func AppSettingOnclick(_ sender:UIButton){
        openAppSettingScreen()
    }
    
    @IBAction func VPNSettingOnclick(_ sender:UIButton){
        openVPNSettingScreen()
    }
    
    @IBAction func accountOnclick(_ sender:UIButton){
        openAccountScreen()
    }
    
    @IBAction func aboutOnclick(_ sender:UIButton){
        openAboutScreen()
    }
    
    @IBAction func helpOnclick(_ sender:UIButton){
        openHelpScreen()
    }
    
    func openAccountScreen(){
        var vc = AccountViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AccountViewController") as! AccountViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openHelpScreen(){
        var vc = HelpViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "HelpViewController") as! HelpViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openAppSettingScreen(){
        var vc = AppSettingsViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AppSettingsViewController") as! AppSettingsViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "AppSettingsViewController") as! AppSettingsViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func openVPNSettingScreen(){
        var vc = VPNSettingViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "VPNSettingViewController") as! VPNSettingViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "VPNSettingViewController") as! VPNSettingViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func openAboutScreen(){
        var vc = AboutViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AboutViewController") as! AboutViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
