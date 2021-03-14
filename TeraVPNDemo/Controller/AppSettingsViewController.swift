//
//  AppSettingsViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 08/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class AppSettingsViewController: UIViewController {

    
    @IBOutlet weak var languageLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Titles.APPLICATION.rawValue.localiz()
        setUpNavBar()
        setLangugeField()
        //let userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)
        
        
    
    }
    
    func setLangugeField(){
        let selectedLanguage = UserDefaults.standard.value(forKey: User_Defaults.selectedLanguage) as? String
        
        if selectedLanguage == Languages.en.rawValue{
            languageLabel.text = "English"
        }
        else if selectedLanguage == Languages.es.rawValue{
            languageLabel.text = "Spanish"
        }
        else if selectedLanguage == Languages.de.rawValue{
            languageLabel.text = "German"
        }
        else if selectedLanguage == Languages.fr.rawValue{
            languageLabel.text = "French"
        }
        else if selectedLanguage == Languages.ar.rawValue{
            languageLabel.text = "Arabic"
        }
        else if selectedLanguage == Languages.ja.rawValue{
            languageLabel.text = "Japanese"
        }
        else if selectedLanguage == Languages.zhHans.rawValue{
            languageLabel.text = "Chinese"
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    
    @IBAction func languageOnclick(_ sender:UIButton){
        openLanguageViewController()
    }
    
    func openLanguageViewController(){
        
        var vc = LanguageViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LanguageViewController") as! LanguageViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpNavBar(){

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    

}
