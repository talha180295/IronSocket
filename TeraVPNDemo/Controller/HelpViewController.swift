//
//  HelpViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 08/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

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
    
    @IBAction func FAQOnclick(_ sender:UIButton){
        openFAQScreen()
    }
    @IBAction func contactOnclick(_ sender:UIButton){
        
    }
    @IBAction func diagnosticOnclick(_ sender:UIButton){
        
    }
    @IBAction func privacyOnclick(_ sender:UIButton){
        openPrivacyScreen()
    }
    @IBAction func termsOnclick(_ sender:UIButton){
        openTermsScreen()
    }
    @IBAction func guidelinesOnclick(_ sender:UIButton){
        openGuidelinesScreen()
    }

    
    func openFAQScreen(){
        var vc = FAQViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "FAQViewController") as! FAQViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func openPrivacyScreen(){
        var vc = PrivacyViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "PrivacyViewController") as! PrivacyViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openTermsScreen(){
        var vc = TermsViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "TermsViewController") as! TermsViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openGuidelinesScreen(){
        var vc = GuidelinesViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "GuidelinesViewController") as! GuidelinesViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "GuidelinesViewController") as! GuidelinesViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
