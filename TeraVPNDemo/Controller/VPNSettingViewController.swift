//
//  VPNSettingViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 08/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class VPNSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
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
