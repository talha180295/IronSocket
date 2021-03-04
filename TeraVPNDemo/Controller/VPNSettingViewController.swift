//
//  VPNSettingViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 08/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class VPNSettingViewController: UIViewController {

    
    @IBOutlet weak var vpnType:UILabel!
    @IBOutlet weak var encryptionLevel:UILabel!
    @IBOutlet weak var loggingLevel:UILabel!
    @IBOutlet weak var startupSwitch:UISwitch!
    @IBOutlet weak var dropSwitch:UISwitch!
    @IBOutlet weak var killSwitch:UISwitch!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Titles.VPN_SETTINGS.rawValue.localiz()
        setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        prepareView()
    }
    
    func prepareView(){
        
        let selectedProto = UserDefaults.standard.value(forKey: User_Defaults.proto) as? String
        let selectedEncryption = UserDefaults.standard.value(forKey: User_Defaults.encryption) as? String
        let selectedLogging = UserDefaults.standard.value(forKey: User_Defaults.logging) as? String
        let selectedStartupSwitch = UserDefaults.standard.value(forKey: User_Defaults.startupSwitch) as? Bool
        let selectedDropSwitch = UserDefaults.standard.value(forKey: User_Defaults.dropSwitch) as? Bool
        let selectedKillSwitch = UserDefaults.standard.value(forKey: User_Defaults.killSwitch) as? Bool
        
        switch selectedProto {
        case Proto_type.udp.rawValue:
            self.vpnType.text = "OpenVPN UDP"
        case Proto_type.tcp.rawValue:
            self.vpnType.text = "OpenVPN TCP"
        case Proto_type.auto.rawValue:
            self.vpnType.text = Titles.AUTOMATIC.rawValue.localiz()
        default:
            self.vpnType.text = Titles.AUTOMATIC.rawValue.localiz()
        }
        
        switch selectedEncryption {
        case Encryption_type.strong.rawValue:
            self.encryptionLevel.text = "Strong"
        case Encryption_type.low.rawValue:
            self.encryptionLevel.text = "Low"
        case Encryption_type.none.rawValue:
            self.encryptionLevel.text = "None"
        default:
            self.encryptionLevel.text = Titles.AUTOMATIC.rawValue.localiz()
        }
        
        switch selectedLogging {
        case Logging_type.none.rawValue:
            self.loggingLevel.text = "None"
        case Logging_type.normal.rawValue:
            self.loggingLevel.text = "Normal"
        case Logging_type.high.rawValue:
            self.loggingLevel.text = "High"
        default:
            self.loggingLevel.text = "None"
        }

        
        self.startupSwitch.isOn = selectedStartupSwitch ?? true
        self.dropSwitch.isOn = selectedDropSwitch ?? true
        self.killSwitch.isOn = selectedKillSwitch ?? true
    
//        switch selectedStartupSwitch {
//        case true:
//            self.startupSwitch.isOn = true
//        case false:
//            self.startupSwitch.isOn = false
//        default:
//            self.startupSwitch.isOn = true
//        }
//
//        switch selectedDropSwitch {
//        case true:
//            self.dropSwitch.isOn = true
//        case false:
//            self.dropSwitch.isOn = false
//        default:
//            self.dropSwitch.isOn = true
//        }
//
//        switch selectedKillSwitch {
//        case true:
//            self.killSwitch.isOn = true
//        case false:
//            self.killSwitch.isOn = false
//        default:
//            self.killSwitch.isOn = true
//        }
    }
    

    @IBAction func protocolOnclick(){
        openProtoScreen(type:"p")
    }
    
    @IBAction func encryptionOnclick(){
        openProtoScreen(type:"e")
    }
    
    @IBAction func logingOnclick(){
        openProtoScreen(type:"l")
    }
    
    @IBAction func startupSwitchChanged(_ sender:UISwitch){
        self.startupSwitch.isOn = sender.isOn
        UserDefaults.standard.set(self.startupSwitch.isOn, forKey: User_Defaults.startupSwitch)
    }
    @IBAction func dropSwitchChanged(_ sender:UISwitch){
        self.dropSwitch.isOn = sender.isOn
        UserDefaults.standard.set(self.dropSwitch.isOn, forKey: User_Defaults.dropSwitch)
    }
    @IBAction func killSwitchChanged(_ sender:UISwitch){
        self.killSwitch.isOn = sender.isOn
        UserDefaults.standard.set(self.killSwitch.isOn, forKey: User_Defaults.killSwitch)
    }
    
    @IBAction func resetBtn(){
        
        UserDefaults.standard.removeObject(forKey: User_Defaults.proto)
        UserDefaults.standard.removeObject(forKey: User_Defaults.encryption)
        UserDefaults.standard.removeObject(forKey: User_Defaults.logging)
        
        UserDefaults.standard.removeObject(forKey: User_Defaults.startupSwitch)
        UserDefaults.standard.removeObject(forKey: User_Defaults.dropSwitch)
        UserDefaults.standard.removeObject(forKey: User_Defaults.killSwitch)
        
        prepareView()
        
        HelperFunc().showAlert(title: "Alert!", message: "Reset To Defaults", controller: self)
    }


    func setUpNavBar(){

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    func openProtoScreen(type:String){
        
        var vc = ProtocolViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ProtocolViewController") as! ProtocolViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ProtocolViewController") as! ProtocolViewController
        }
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


