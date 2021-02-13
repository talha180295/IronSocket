//
//  HelpDetailViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 14/02/2021.
//  Copyright © 2021 abc. All rights reserved.
//

import UIKit

class HelpDetailViewController: UIViewController {

    @IBOutlet weak  var detailView:UITextView!
    
    var titleStr:String!
    var details:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setDetails()
        //let userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)
        
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    func setUpNavBar(){

        self.title = titleStr
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setDetails(){
        self.detailView.attributedText = self.details.htmlToAttributedString
    }
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
