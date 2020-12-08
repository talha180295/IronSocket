//
//  ProtocolViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 09/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class ProtocolViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
    }
    
    func setUpNavBar(){

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

}
