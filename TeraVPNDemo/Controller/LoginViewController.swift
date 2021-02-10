//
//  LoginViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 16/09/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTF:UITextField!
    @IBOutlet weak var passwordTF:UITextField!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var checkbox:CheckboxButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        usernameTF.text  = "test@user.com"
//        passwordTF.text  = "q0D5whHYs"
//
//
        
//        usernameTF.text  = "uzair@cyberdude.com"
//        passwordTF.text  = "abc123"
        

        usernameTF.text  = "vpn_izy70k8b"
        passwordTF.text  = "abc"
        
//        loginBtn.setGradiantColors(colours: [UIColor(hexString: "#2B1468").cgColor, UIColor(hexString: "#70476F").cgColor])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func loginBtn(_ sender:UIButton){
        
        if checkbox.on {
          print("Remember pass Checkbox is checked")
        }
        
//        var vc = VPNViewController()
//        if #available(iOSApplicationExtension 13.0, *) {
//            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "VPNViewController") as! VPNViewController
//
//        } else {
//            vc = self.storyboard?.instantiateViewController(withIdentifier: "VPNViewController") as! VPNViewController
//        }
        
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let params = ["username":usernameTF.text!,"password":passwordTF.text!]

        let request = APIRouter.login(params)
        NetworkService.serverRequest(url: request, dec: LoginResponse.self, view: self.view) { (loginResponse, error) in

            if loginResponse != nil{
                print("**********loginResponse**********")
                print(loginResponse!)
                print("**********loginResponse**********")
            }
            else if error != nil{
                print("**********loginResponse**********")
                print(error!)
                print("**********loginResponse**********")
            }

            if loginResponse?.success == "true"{

                var vc = VPNViewController()
                if #available(iOSApplicationExtension 13.0, *) {
                    vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "VPNViewController") as! VPNViewController

                } else {
                    vc = self.storyboard?.instantiateViewController(withIdentifier: "VPNViewController") as! VPNViewController
                }

                vc.serverList = loginResponse?.server ?? [Server]()
                vc.username = loginResponse?.username
                vc.password = loginResponse?.password
//                vc.usagelimit = Double(loginResponse?.usage?.usagelimit ?? "0")
//                vc.usageRemaining = Double(loginResponse?.usage?.remaining ?? 0)

                let userCredentials = UserCredentials.init(username: self.usernameTF.text!, password: self.passwordTF.text!)
                HelperFunc().deleteUserDefaultData(title: User_Defaults.userCredentials)
                HelperFunc().saveUserDefaultData(data: userCredentials, title: User_Defaults.userCredentials)

                HelperFunc().deleteUserDefaultData(title: User_Defaults.user)
                HelperFunc().saveUserDefaultData(data: loginResponse, title: User_Defaults.user)
                self.navigationController?.pushViewController(vc, animated: true)

            }

        }
        
    }
    
}


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

import UIKit
class GradientButton: UIButton {

    private var colors:[Any]!
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//    
    func setGradiantColors(colours: [Any]){
        self.colors = colours
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = self.colors
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 16
        layer.insertSublayer(l, at: 0)
        return l
    }()
}



