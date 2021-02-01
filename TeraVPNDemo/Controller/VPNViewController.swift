//
//  VPNViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 17/09/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation
import NetworkExtension
import SDWebImage
import LMGaugeViewSwift
import MMWormhole


class VPNViewController: UIViewController {
    
    var userData: LoginResponse!
    
    var timer : Timer?
    var timer2 : Timer?
    
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    var state = 0
    //    var usage:UsageResponse!
    // = 30210912720
    
    var usagelimitInMbs:Double = 0.0// =      32210912720
    var usageRemainingInMbs: Double = 0.0// = 30210912720
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.abc.org.IronSocket", optionalDirectory: "wormhole")
    
    let protoJson = """
                        {
                          "tcp": {
                            "none": [
                              "rport 441",
                              "proto tcp",
                              "cipher none"
                            ],
                            "low": [
                              "rport 442",
                              "proto tcp",
                              "cipher BF-CBC"
                            ],
                            "strong": [
                              "rport 443",
                              "proto tcp",
                              "cipher AES-128-GCM"
                            ]
                          },
                          "udp": {
                            "none": [
                              "rport 441",
                              "proto udp",
                              "cipher none",
                              "explicit-exit-notify"
                            ],
                            "low": [
                              "rport 442",
                              "proto udp",
                              "cipher BF-CBC",
                              "explicit-exit-notify"
                            ],
                            "strong": [
                              "rport 443",
                              "proto udp",
                              "cipher AES-128-GCM",
                              "explicit-exit-notify"
                            ]
                          }
                        }
                      """
    
    @IBOutlet weak var flag:UIImageView!
    @IBOutlet weak var countryName:UILabel!
    @IBOutlet weak var protocolNameLabel:UIButton!
    @IBOutlet weak var timmer:UILabel!
    @IBOutlet weak var circularView: CircularProgressView!
    @IBOutlet weak var signal1: UIButton!
    @IBOutlet weak var signal2: UIButton!
    @IBOutlet weak var signal3: UIButton!
    @IBOutlet weak var serverIP:UILabel!
    @IBOutlet weak var dataRecieved:UILabel!
    @IBOutlet weak var dataSent:UILabel!
    @IBOutlet weak var connectionStatus:UILabel!
    @IBOutlet weak var connectBtn:UIButton!
    @IBOutlet weak var grayView1:UIView!

    
    //Intent Variables
    var serverList = [Server]()
    var username:String!
    var password:String!

    
    
    //VPN Data Variables
    var dataSentInMbs = 0.0
    var dataRecievedInMbs = 0.0
    
    //VPN Var
    let tunnelBundleId = "\(Bundle.main.bundleIdentifier!).PacketTunnel"
    var providerManager = NETunnelProviderManager()
    var selectedIP : String!
    var isVPNConnected : Bool = false
    var duration: TimeInterval!
    var circularProgressTimer:Timer!
    var signalTimer:Timer!
    var selectedSignal = 0
    
    
    var count = 0

    func startTimerLabel () {
        guard timer2 == nil else { return }
        
        timer2 =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1),
            target      : self,
            selector    : #selector(VPNViewController.update),
            userInfo    : nil,
            repeats     : true)
    }
    func stopTimerLabel() {
        timer2?.invalidate()
        timer2 = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disconnected()

        self.circularView.alpha = 0.4
        self.userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VPNViewController.VPNStatusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        
        self.title = "TeraVPN"
        
        self.selectedIP = "\(serverList.first?.serverIP ?? "0")"//" \(serverList.first?.serverPort ?? "0")"
        self.serverIP.text = "\(serverList.first?.serverIP ?? "0")"//" \(serverList[0].serverPort ?? "0")"
        self.countryName.text = "\(serverList.first?.country ?? "") , \(serverList.first?.city ?? "")"
//        self.cityName.text = "\(serverList.first?.city ?? "")"
        self.flag.image = UIImage.init(named: serverList.first?.flag ?? "")
        
        self.connectionStatus.text = "Disconnected"
//        self.connectionStatus.textColor = .red
//        self.connectionBtn.backgroundColor = UIColor(hexString: "3CB371")
        
        
        self.dataSent.text = "\(self.dataSentInMbs) MB"
        self.dataRecieved.text = "\(self.dataRecievedInMbs) MB"

        

    }
    
    @objc func update() {
        if self.seconds == 59 {
            self.seconds = 0
            if self.minutes == 59 {
                self.minutes = 0
                self.hours = self.hours + 1
            } else {
                self.minutes = self.minutes + 1
            }
        } else {
            self.seconds = self.seconds + 1
        }
      
        var h = ""
        var m = ""
        var s = ""
        
        if self.hours < 10{
            h = "0"
        }
        if self.minutes < 10{
            m = "0"
        }
        if self.seconds < 10{
            s = "0"
        }
        self.timmer.text = "\(h)\(self.hours):\(m)\(self.minutes):\(s)\(self.seconds)"
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupProtocolLabel()
    }
    
    
    func setupProtocolLabel(){
        guard let selectedProto = UserDefaults.standard.value(forKey: User_Defaults.proto) as? String else {
            
            self.protocolNameLabel.setTitle("PROTOCOL: OpenVPN - TCP", for: .normal)
            return
        }
        
        self.protocolNameLabel.setTitle("PROTOCOL: OpenVPN - \(selectedProto.uppercased())", for: .normal)
    }
    
    
    
    @IBAction func connectBtn(_ sender:UIButton){

        
        if state == 0{

            self.connecting()
            self.state = 1
        }
        else if state == 1{

            self.connected()
            self.state = 2
        }
        else if state == 2{

            self.disconnected()
            self.state = 0
        }
//        self.connectVpn()

       
        
    }
    
    
    @IBAction func sideMenuBtn(_ sender:UIBarButtonItem){
        
        var vc = LocationViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LocationViewController") as! LocationViewController
        } else {
            vc = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        }
        vc.serverList = self.serverList
        vc.delegate = self

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //For logout
    @IBAction func settingsBtn(_ sender:UIButton){
        
        var vc = DemoViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DemoViewController") as! DemoViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "DemoViewController") as! DemoViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
//        self.openSettingsScreen()
       
    }
    
    func openSettingsScreen(){
        var vc = SettingsViewController()
        if #available(iOSApplicationExtension 13.0, *) {
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController

        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        }
        vc.serverList = self.serverList
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


//VPN
extension VPNViewController{
    
    
    func connectVpn(){
        
//        self.stopTimer3()
//        self.stopTimer4()
        if isVPNConnected == true {
            
            let alert = UIAlertController(title: "Cancel Confirmation", message: "Disconnect the connected VPN cancel the connection attempt?", preferredStyle: UIAlertController.Style.alert)
            
            let disconnectAction = UIAlertAction(title: "DISCONNECT", style: UIAlertAction.Style.destructive) { _ in
                self.providerManager.connection.stopVPNTunnel()
                self.disconnected()
            }
            
            let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            // relate actions to controllers
            alert.addAction(disconnectAction)
            
            alert.addAction(dismiss)
            
            present(alert, animated: true, completion: nil)
        }
        else{
            
            let otherAlert = UIAlertController(title: "IronSocket VPN", message: "Are you sure access VPN Connection", preferredStyle: UIAlertController.Style.alert)
            
            let connectAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) { _ in
                
                
                
                let password = self.userData?.password ?? ""
                let username = self.userData?.username ?? ""
                self.loadProviderManager {
//                    self.configureVPN(serverAddress: self.selectedIP, username: self.username, password: "dcd76cbc5ad008a")dfe334f1a50535f
                    self.configureVPN(serverAddress: "", username: username, password:password)
                    self.connecting()
                    
                }
                
            }
            
            let dismiss = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil)
            
            // relate actions to controllers
            otherAlert.addAction(connectAction)
            
            otherAlert.addAction(dismiss)
            
            present(otherAlert, animated: true, completion: nil)
            
            
        }
        
    }
    
    func loadProviderManager(completion:@escaping () -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            if error == nil {
                self.providerManager = managers?.first ?? NETunnelProviderManager()
                completion()
            }
        }
    }
    
    func configureVPN(serverAddress: String, username: String, password: String) {
        
        
        guard let configurationFileContent = self.getFileData(path: "android-version3") else { return }
        
        self.providerManager.loadFromPreferences { error in
            if error == nil {
                let tunnelProtocol = NETunnelProviderProtocol()
//                tunnelProtocol.username = username
                tunnelProtocol.serverAddress = serverAddress
                tunnelProtocol.providerBundleIdentifier = self.tunnelBundleId// bundle id of the network extension target
                //                tunnelProtocol.providerConfiguration = ["ovpn": configurationFileContent as NSData,"u":"test@user.com" as! String ,"p":"dcd76cbc5ad008a" as! String]
                
                tunnelProtocol.providerConfiguration = ["ovpn": configurationFileContent, "username": username, "password": password]
                
                tunnelProtocol.disconnectOnSleep = false
                self.providerManager.protocolConfiguration = tunnelProtocol
                self.providerManager.localizedDescription = "TeraVPN" // the title of the VPN profile which will appear on Settings
                self.providerManager.isEnabled = true
                self.providerManager.saveToPreferences(completionHandler: { (error) in
                    if error == nil  {
                        self.providerManager.loadFromPreferences(completionHandler: { (error) in
                            do {
                                try self.providerManager.connection.startVPNTunnel() // starts the VPN tunnel.
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        })
                    }
                })
            }
            else{
                print(error.debugDescription)
            }
        }
    }
    
    func getFileData(path: String) -> Data?{
        
        var constr : String!
        
        guard let content = self.readFile(path: path) else { return nil }
        
        constr = content
        
//        constr = constr.replacingOccurrences(of: "remote ip", with: "remote \(self.selectedIP ?? "")")
        constr = setProto(str: constr)
        print("selectedIP=\(self.selectedIP ?? "")")
//        constr = constr.replacingOccurrences(of: "remote ip", with: "remote \(self.selectedIP ?? "") 443"
        constr = constr.replacingOccurrences(of: "\r\n", with: "\n")
        
//        if let adBlocker = UserDefaults.standard.value(forKey: User_Defaults.adBlocker) as? Bool{
//
//            if adBlocker{
//                constr = constr.replacingOccurrences(of: "dhcp-option DNS 8.8.8.8", with: "dhcp-option DNS 8.8.8.8 \(self.userData.adblocker ?? "")")
//            }
//
//        }
        
        
        print("constr=\n\(constr as String)")
        return (constr as String).data(using: String.Encoding.utf8)! as Data
        
        
    }
    
    func setProto(str:String) -> String{
        
        var newStr = str
//        let protoModel = try! JSONDecoder().decode(Proto.self, from: protoJson.data(using: .utf8)!)


        let selectedProto = UserDefaults.standard.value(forKey: User_Defaults.proto) as? String
        let selectedEncryption = UserDefaults.standard.value(forKey: User_Defaults.encryption) as? String
        
        let data = Data(protoJson.utf8)
        
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                if let jsonArr = json[selectedProto ?? "tcp"] as? [String:Any] {
                    
                    if let value = jsonArr[selectedEncryption ?? "strong"] as? [String]{
                        let port  = (value[0]).split(separator: " ")
                             
                        print("==\(port)\n")
                        print("==\(port[1])")
                        newStr = newStr.replacingOccurrences(of: "remote ip", with: "remote \(self.selectedIP ?? "") \(port[1])")
                        newStr = newStr.replacingOccurrences(of: "rport", with: "\(value[0])")
                        newStr = newStr.replacingOccurrences(of: "proto", with: "\(value[1])")
                        if selectedProto == "udp"{
                            newStr = newStr.replacingOccurrences(of: "encryption", with: "\(value[2])\n\(value[3])")
                        }
                        else{
                            newStr = newStr.replacingOccurrences(of: "encryption", with: "\(value[2])")
                        }
                    }
                    
                    
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        return newStr
    }
    
    func readFile(path: String) -> String? {
        
//        let port = UInt16(1994)
//        print(isPortOpen(port:port))
        
        if let filepath = Bundle.main.path(forResource: path, ofType: "ovpn") {
            do {
                let contents = try String(contentsOfFile: filepath)
                
                return contents
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            
        }
        
        return nil
    }
    

    
    @objc func VPNStatusDidChange(_ notification: Notification?) {
        print("VPN Status changed:")
        
        let status = self.providerManager.connection.status
        switch status {
        case .connecting:
            isVPNConnected = true
            print("Connecting...")
            self.connectionStatus.text = "Connecting...".uppercased()

            
            
            break
        case .connected:
            isVPNConnected = true
            print("Connected...")
            self.connectionStatus.text = "Connected".uppercased()

            self.connected()

            

            
            break
        case .disconnecting:
            print("Disconnecting...")
            self.connectionStatus.text = "Disconnecting...".uppercased()
            break
        case .disconnected:
            isVPNConnected = false
            print("Disconnected...")
            self.connectionStatus.text = "Disconnected".uppercased()

            
            
            break
        case .invalid:
            print("Invliad")
            break
        case .reasserting:
            print("Reasserting...")
            break
        @unknown default:
            print("Fatel Error...")
            break
        }
    }
}


extension VPNViewController:ServerListProtocol{
    
    func selectServer(server: Server) {
        if isVPNConnected{
            self.providerManager.connection.stopVPNTunnel()
        }
        
        self.selectedIP = "\(server.serverIP ?? "0")"//" \(server.serverPort ?? "0")"
        self.serverIP.text = server.serverIP
        self.countryName.text = "\(server.country ?? "") , \(server.city ?? "")"
//        self.cityName.text = "\(server.city ?? "")"
        self.flag.image = UIImage.init(named: server.flag ?? "")
        
    }
    
    
}

extension VPNViewController:SettingServerListProtocol{
    
    func settingSelectServer(server: Server) {
        if isVPNConnected{
            self.providerManager.connection.stopVPNTunnel()
        }
        
        self.selectedIP = "\(server.serverIP ?? "0")"//" \(server.serverPort ?? "0")"
        self.serverIP.text = server.serverIP
        self.countryName.text = "\(server.country ?? "") , \(server.city ?? "")"
//        self.cityName.text = "\(server.city ?? "")"
        self.flag.image = UIImage.init(named: server.flag ?? "")
        
    }
    
    
}



extension UIButton{

    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }

}

//Loader Animation
extension VPNViewController{
    
    
    func startCircularTimer() {
        circularProgressTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(3),
            target      : self,
            selector    : #selector(VPNViewController.circularProgrress),
            userInfo    : nil,
            repeats     : true)
    }
    @objc func circularProgrress() {
        duration = 3    //Play with whatever value you want :]
        circularView.progressAnimation(duration: duration)
        
    }
    func stopCircularTimer() {
        circularProgressTimer?.invalidate()
        circularProgressTimer = nil
    }
    
    func startSignalTimer() {
        signalTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(0.5),
            target      : self,
            selector    : #selector(VPNViewController.signalProgrress),
            userInfo    : nil,
            repeats     : true)
    }
    @objc func signalProgrress() {
       
        switch selectedSignal {
        case 0:
            signal1.setImageTintColor(UIColor.AntennaConnecting)
            signal2.setImageTintColor(UIColor.black)
            signal3.setImageTintColor(UIColor.black)
            selectedSignal = 1
        case 1:
            signal1.setImageTintColor(UIColor.black)
            signal2.setImageTintColor(UIColor.AntennaConnecting)
            signal3.setImageTintColor(UIColor.black)
            selectedSignal = 2
        case 2:
            signal1.setImageTintColor(UIColor.black)
            signal2.setImageTintColor(UIColor.black)
            signal3.setImageTintColor(UIColor.AntennaConnecting)
            selectedSignal = 0
        default:
            break
        }
    }
    func stopSignalTimer() {
        signalTimer?.invalidate()
        signalTimer = nil
        selectedSignal = 0
    }
    
}

extension VPNViewController{
    

    
    func connecting(){
        circularView.progressLayer.isHidden = false
        circularView.progressLayer.strokeColor = UIColor.ButtonConnecting.cgColor
        self.connectBtn.setImageTintColor(UIColor.ButtonConnecting)
        circularProgrress()
        startCircularTimer()
        startSignalTimer()
        stopTimerLabel()
        
    }
    func connected(){
        duration = 0
        circularView.progressAnimation(duration: duration)
        circularView.progressLayer.isHidden = false
        circularView.progressLayer.strokeColor = UIColor.ButtonConnected.cgColor
        connectBtn.setImageTintColor(UIColor.ButtonConnected)
        signal1.setImageTintColor(UIColor.AntennaConnected)
        signal2.setImageTintColor(UIColor.AntennaConnected)
        signal3.setImageTintColor(UIColor.AntennaConnected)
        
//        startCircularTimer()
//        startSignalTimer()
//        stopTimerLabel()
        stopCircularTimer()
        stopSignalTimer()
        startTimerLabel()
    }
    func disconnected(){
        duration = 0
        circularView.progressAnimation(duration: duration)
        circularView.progressLayer.isHidden = false
        circularView.progressLayer.strokeColor = UIColor.ButtonDisconnected.cgColor
        signal1.setImageTintColor(UIColor.AntennaDisconnected)
        signal2.setImageTintColor(UIColor.AntennaDisconnected)
        signal3.setImageTintColor(UIColor.AntennaDisconnected)
        connectBtn.setImageTintColor(UIColor.ButtonDisconnected)
        
//        startCircularTimer()
//        startSignalTimer()
        
        stopCircularTimer()
        stopSignalTimer()
        
        stopTimerLabel()
    }
}
