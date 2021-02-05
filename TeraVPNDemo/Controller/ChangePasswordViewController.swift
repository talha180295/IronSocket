//
//  ChangePasswordViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 07/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

   
    @IBOutlet weak var oldPassTF:UITextField!
    @IBOutlet weak var newPassTF:UITextField!
    @IBOutlet weak var confNewPassTF:UITextField!
    var userData: LoginResponse?
    
    var passChangeedSuccsesfull : ((Bool,String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)        
        self.oldPassTF.text = userData?.password!
        self.oldPassTF.isHidden = true
        
        oldPassTF.isSecureTextEntry = true
        newPassTF.isSecureTextEntry = true
        confNewPassTF.isSecureTextEntry = true
        
        setUpNavBar()
    }
    
    func setUpNavBar(){

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    @IBAction func btnClick(_ sender:UIButton){
        if validation(){
            changePassword()
        }
    }
    
    func validation() -> Bool{
        
        if newPassTF.text != confNewPassTF.text{
            HelperFunc().showAlert(title: "Alert", message: "Passwords does not matched!", controller: self)
            return false
        }
        return true
    }
    
    
    func changePassword(){
        
                
        let params = ["username": userData?.username ?? "", "password": oldPassTF.text!, "newpass": newPassTF.text!, "plan_id": userData?.planID ?? 0] as [String : Any]

        let request = APIRouter.changePass(params)
        NetworkService.serverRequest(url: request, dec: ChangePassResponse.self, view: self.view) { (changePassResponse, error) in

            if changePassResponse != nil{
                print("**********loginResponse**********")
                print(changePassResponse!)
                print("**********loginResponse**********")
            }
            else if error != nil{
                print("**********loginResponse**********")
                print(error!)
                print("**********loginResponse**********")
            }

            if changePassResponse?.success == "true"{

                let userCredentials = UserCredentials.init(username: self.userData?.username ?? "", password: self.newPassTF.text!)
                HelperFunc().deleteUserDefaultData(title: User_Defaults.userCredentials)
                HelperFunc().saveUserDefaultData(data: userCredentials, title: User_Defaults.userCredentials)

                self.userData?.password = self.newPassTF.text!
                
                HelperFunc().deleteUserDefaultData(title: User_Defaults.user)
                HelperFunc().saveUserDefaultData(data: self.userData, title: User_Defaults.user)
                self.passChangeedSuccsesfull(true, changePassResponse?.message ?? "")
                self.navigationController?.popViewController(animated: true)

            }

        }
        
    }
}
