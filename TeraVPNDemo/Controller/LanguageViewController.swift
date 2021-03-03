//
//  LanguageViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 28/02/2021.
//  Copyright © 2021 abc. All rights reserved.
//

import UIKit
import LanguageManager_iOS



class LanguageViewController: UIViewController {
    
    
    
    let languagesArray =  [
        (name:"English", code:0),
        (name:"Spanish", code:1)
    ]
    
    
    @IBOutlet weak var languageTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Titles.LANGUAGES.rawValue.localiz()
        //        HelperFunc().registerTableCell(tableView: languageTableView, nibName: "LanguageCell", identifier: "LanguageCell")
        languageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
        languageTableView.delegate = self
        languageTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    //    @IBAction func enOnclick(_ sender:UIButton){
    //        LanguageManager.shared.setLanguage(language: .en)
    //        UserDefaults.standard.setValue(Languages.en.rawValue, forKey: User_Defaults.selectedLanguage)
    //        self.navigationController?.popViewController(animated: true)
    //    }
    //
    //    @IBAction func esOnclick(_ sender:UIButton){
    //        LanguageManager.shared.setLanguage(language: .es)
    //        UserDefaults.standard.setValue(Languages.es.rawValue, forKey: User_Defaults.selectedLanguage)
    //        self.navigationController?.popViewController(animated: true)
    //    }
    
}


extension LanguageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        
        cell.textLabel?.text = languagesArray[indexPath.row].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch languagesArray[indexPath.row].code {
        case 0:
            LanguageManager.shared.setLanguage(language: .en)
            { title -> UIViewController in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // the view controller that you want to show after changing the language
                return storyboard.instantiateInitialViewController()!
            } animation: { view in
                // do custom animation
                view.transform = CGAffineTransform(scaleX: 2, y: 2)
                view.alpha = 0
            }
            UserDefaults.standard.setValue(Languages.en.rawValue, forKey: User_Defaults.selectedLanguage)
        //            self.navigationController?.popViewController(animated: true)
        case 1:
            LanguageManager.shared.setLanguage(language: .es)
            { title -> UIViewController in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // the view controller that you want to show after changing the language
                return storyboard.instantiateInitialViewController()!
            } animation: { view in
                // do custom animation
                view.transform = CGAffineTransform(scaleX: 2, y: 2)
                view.alpha = 0
            }
            UserDefaults.standard.setValue(Languages.es.rawValue, forKey: User_Defaults.selectedLanguage)
//            self.navigationController?.popViewController(animated: true)

        default:
            break
        }
    }
    
    
    
    func getWindowsToChangeFrom(){

    }
    
}
