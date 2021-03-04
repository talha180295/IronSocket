//
//  ProtocolViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 09/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import RadioGroup

class ProtocolViewController: UIViewController {

    
//    @IBOutlet var saveBtn: UIBarButtonItem!
    @IBOutlet var radioGroup: RadioGroup!
    
    var type:String!
    var selectedProto = UserDefaults.standard.value(forKey: User_Defaults.proto) as? String
    var selectedEncryption = UserDefaults.standard.value(forKey: User_Defaults.encryption) as? String
    var selectedLogging = UserDefaults.standard.value(forKey: User_Defaults.logging) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
        if type == "p"{
            self.title = Titles.VPN_PROTOCOL.rawValue.localiz()
            setupProtoRadioGroup()
        }
        else if type == "e"{
            self.title = Titles.ENCRYPTION_LEVEL.rawValue.localiz()
            setupEncryptionRadioGroup()
        }
        else if type == "l"{
            self.title = Titles.LOGGING_LEVEL.rawValue.localiz()
            setupLogingRadioGroup()
        }
    }
    
    func setUpNavBar(){

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupProtoRadioGroup(){
        radioGroup.titles = ["\(Titles.AUTOMATIC.rawValue.localiz())", "OpenVPN - UDP", "OpenVPN - TCP"]
        radioGroup.addTarget(self, action: #selector(didSelectProtoOption(radioGroup:)), for: .valueChanged)
        switch selectedProto {
        case Proto_type.auto.rawValue:
            radioGroup.selectedIndex = 0
        case Proto_type.udp.rawValue:
            radioGroup.selectedIndex = 1
        case Proto_type.tcp.rawValue:
            radioGroup.selectedIndex = 2
        default:
            radioGroup.selectedIndex = 0
        }
        
    }
    
    func setupEncryptionRadioGroup(){
        radioGroup.titles = ["\(Titles.AUTOMATIC.rawValue.localiz())", "Strong", "Low", "None"]
        radioGroup.addTarget(self, action: #selector(didSelectEncryptionOption(radioGroup:)), for: .valueChanged)
        switch selectedEncryption {
        case Encryption_type.auto.rawValue:
            radioGroup.selectedIndex = 0
        case Encryption_type.strong.rawValue:
            radioGroup.selectedIndex = 1
        case Encryption_type.low.rawValue:
            radioGroup.selectedIndex = 2
        case Encryption_type.none.rawValue:
            radioGroup.selectedIndex = 3
        default:
            radioGroup.selectedIndex = 0
        }
    }
    
    func setupLogingRadioGroup(){
        radioGroup.titles = ["None", "Normal", "High"]
        radioGroup.addTarget(self, action: #selector(didSelectLoggingOption(radioGroup:)), for: .valueChanged)
        switch selectedLogging {
        case Logging_type.none.rawValue:
            radioGroup.selectedIndex = 0
        case Logging_type.normal.rawValue:
            radioGroup.selectedIndex = 1
        case Logging_type.high.rawValue:
            radioGroup.selectedIndex = 2
        default:
            radioGroup.selectedIndex = 0
        }
    }

    @objc func didSelectProtoOption(radioGroup: RadioGroup) {
        print(radioGroup.titles[radioGroup.selectedIndex] ?? "")
        switch radioGroup.selectedIndex {
        case 0:
            selectedProto = Proto_type.auto.rawValue
//            UserDefaults.standard.set("tcp", forKey: User_Defaults.proto)
        case 1:
            selectedProto = Proto_type.udp.rawValue
//            UserDefaults.standard.set("udp", forKey: User_Defaults.proto)
        case 2:
            selectedProto = Proto_type.tcp.rawValue
//            UserDefaults.standard.set("tcp", forKey: User_Defaults.proto)
        default:
            selectedProto = Proto_type.tcp.rawValue
//            UserDefaults.standard.set("tcp", forKey: User_Defaults.proto)
        }
    }
    
    @objc func didSelectEncryptionOption(radioGroup: RadioGroup) {
        print(radioGroup.titles[radioGroup.selectedIndex] ?? "")
        switch radioGroup.selectedIndex {
        case 0:
            selectedEncryption = Encryption_type.auto.rawValue
//            UserDefaults.standard.set("strong", forKey: User_Defaults.encryption)
        case 1:
            selectedEncryption = Encryption_type.strong.rawValue
//            UserDefaults.standard.set("strong", forKey: User_Defaults.encryption)
        case 2:
            selectedEncryption = Encryption_type.low.rawValue
//            UserDefaults.standard.set("low", forKey: User_Defaults.encryption)
        case 3:
            selectedEncryption = Encryption_type.none.rawValue
//            UserDefaults.standard.set("none", forKey: User_Defaults.encryption)
        default:
            selectedEncryption = Encryption_type.strong.rawValue
//            UserDefaults.standard.set("strong", forKey: User_Defaults.encryption)
        }
    }
    
    
    @objc func didSelectLoggingOption(radioGroup: RadioGroup) {
        print(radioGroup.titles[radioGroup.selectedIndex] ?? "")
        switch radioGroup.selectedIndex {
        case 0:
            selectedLogging = Logging_type.none.rawValue
        case 1:
            selectedLogging = Logging_type.normal.rawValue
        case 2:
            selectedLogging = Logging_type.high.rawValue
        default:
            selectedLogging = Logging_type.none.rawValue
        }
    }
    
    @IBAction func saveBtn( _ sender:UIButton){
        
        UserDefaults.standard.set(selectedProto, forKey: User_Defaults.proto)
        UserDefaults.standard.set(selectedEncryption, forKey: User_Defaults.encryption)
        UserDefaults.standard.set(selectedEncryption, forKey: User_Defaults.logging)
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
