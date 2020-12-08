//
//  FAQViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 08/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {

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

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    


}
