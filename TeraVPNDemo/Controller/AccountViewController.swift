//
//  AccountViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 07/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var username:UILabel!
    @IBOutlet weak var plan:UILabel!
    @IBOutlet weak var renewDate:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
        
        let userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)
        username.text = userData?.username ?? ""
        plan.text = userData?.package ?? ""
        renewDate.text = userData?.nextdue ?? ""
    }
    

    @IBAction func passwordOnclick(){
        openPasswordScreen()
    }

    func setUpNavBar(){

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func openPasswordScreen(){
        var vc = PasswordViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "PasswordViewController") as! PasswordViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
