//
//  SettingsViewController.swift
//  TeraVPNDemo
//
//  Created by talha on 20/10/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

protocol SettingServerListProtocol {
    func settingSelectServer(server:Server)
}

class SettingsViewController: UIViewController {

    var serverList = [Server]()
    var selectedServer = Server()
    var delegate:SettingServerListProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Titles.SETTINGS.rawValue.localiz()
        
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
    
    @IBAction func LocationOnclick(_ sender:UIButton){
        
        if let _ = getConnectedVpnData(){
            HelperFunc().showToast(message: "Disconnect VPN to change the Location", controller: self)
            return
        }
        
        var vc = LocationViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LocationViewController") as! LocationViewController
        } else {
            vc = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        }
        vc.serverList = self.serverList
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func speedOnclick(_ sender:UIButton){
        openSpeedTestScreen()
    }
    
    //For logout
    @IBAction func logoutBtn(_ sender:UIButton){
        
        let alert = UIAlertController(title: Titles.LOGOUT.rawValue.localiz(), message: Titles.ARE_YOU_SURE_TO_LOGOUT.rawValue.localiz(), preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: Titles.YES.rawValue.localiz(), style: UIAlertAction.Style.destructive) { _ in
            self.logout()
        }
        
        let noAction = UIAlertAction(title: Titles.NO.rawValue.localiz(), style: UIAlertAction.Style.cancel, handler: nil)
        
        // relate actions to controllers
        alert.addAction(yesAction)
        
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func logout(){
        
        HelperFunc().deleteUserDefaultData(title: User_Defaults.user)
        HelperFunc().deleteUserDefaultData(title: User_Defaults.userCredentials)
        HelperFunc().deleteUserDefaultData(title: User_Defaults.adBlocker)
        
        openLoginScreen()
    }
    
    
    func openLoginScreen(){
        var vc = LoginViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController") as! LoginViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func openSpeedTestScreen(){
        var vc = SpeedTestViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "SpeedTestViewController") as! SpeedTestViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "SpeedTestViewController") as! SpeedTestViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}


extension SettingsViewController:ServerListProtocol{
    
    func selectServer(server: Server) {
//        self.selectedServer = server
        self.delegate.settingSelectServer(server: server)
        self.navigationController?.popViewController(animated: true)
//        if isVPNConnected{
//            self.providerManager.connection.stopVPNTunnel()
//        }
//
//        self.selectedIP = "\(server.serverIP ?? "0")"//" \(server.serverPort ?? "0")"
//        self.serverIP.text = server.serverIP
//        self.countryName.text = "\(server.country ?? "")"
////        self.cityName.text = "\(server.city ?? "")"
//        self.flag.image = UIImage.init(named: server.flag ?? "")
        
    }
    
    func getConnectedVpnData() -> Server?{
        let connectedServer = HelperFunc().getUserDefaultData(dec: Server.self, title: User_Defaults.connectedServer)
        return connectedServer
    }
}
