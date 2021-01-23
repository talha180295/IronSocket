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
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let selectedProto = UserDefaults.standard.value(forKey: User_Defaults.proto) as? String
        let selectedEncryption = UserDefaults.standard.value(forKey: User_Defaults.encryption) as? String
        
        switch selectedProto {
        case Proto_type.udp.rawValue:
            self.vpnType.text = "OpenVPN UDP"
        case Proto_type.tcp.rawValue:
            self.vpnType.text = "OpenVPN TCP"
        default:
            self.vpnType.text = "OpenVPN TCP"
        }
        
        switch selectedEncryption {
        case Encryption_type.strong.rawValue:
            self.encryptionLevel.text = "Strong"
        case Encryption_type.low.rawValue:
            self.encryptionLevel.text = "Low"
        case Encryption_type.none.rawValue:
            self.encryptionLevel.text = "None"
        default:
            self.encryptionLevel.text = "Strong"
        }
        
    }

    @IBAction func protocolOnclick(){
        openProtoScreen(type:"p")
    }
    
    @IBAction func encryptionOnclick(){
        openProtoScreen(type:"e")
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
