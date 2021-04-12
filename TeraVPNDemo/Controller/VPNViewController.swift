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
    var selectedServer:Server!
    
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
    @IBOutlet weak var locationBtn:UIButton!
    
    
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

    
    func startTimerTrafficStats () {
        guard timer == nil else { return }
        
        timer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(0.3),
            target      : self,
            selector    : #selector(getTrafficStats),
            userInfo    : nil,
            repeats     : true)
    }
    
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
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
        
        self.timmer.text = "00:00:00"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disconnected()

        self.grayView1.backgroundColor = UIColor.themeGray
        self.circularView.alpha = 1
        self.signal1.alpha = 0.8
        self.signal2.alpha = 0.8
        self.signal3.alpha = 0.8
        self.locationBtn.semanticContentAttribute = .forceRightToLeft
        self.userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VPNViewController.VPNStatusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        
        self.selectedIP = "\(serverList.first?.serverIP ?? "0")"//" \(serverList.first?.serverPort ?? "0")"
        self.serverIP.text = getIPAddress() //"\(serverList.first?.serverIP ?? "0")"//" \(serverList[0].serverPort ?? "0")"
        self.countryName.text = "\(serverList.first?.country ?? "") , \(serverList.first?.city ?? "")"
//        self.cityName.text = "\(serverList.first?.city ?? "")"
        self.flag.image = UIImage.init(named: serverList.first?.flag ?? "")
        
        self.connectionStatus.text = Titles.VPN_STATE_DISCONNECTED.rawValue.localiz().uppercased()

        
        self.dataSent.text = "\(self.dataSentInMbs) MB"
        self.dataRecieved.text = "\(self.dataRecievedInMbs) MB"

        self.selectedServer = serverList.first
        
        self.loadProviderManager {
            if self.checkConnectionOnstartup(){
                if self.providerManager.connection.status == .disconnected || self.providerManager.connection.status == .invalid {
                    self.connectVpn()
                }
            }
            if self.providerManager.connection.status == .connected {
                if let connectedServer = self.getConnectedVpnData(){
                    
                    self.connected()
                    self.selectedIP = "\(connectedServer.serverIP ?? "0")"//" \(server.serverPort ?? "0")"
                    self.serverIP.text = connectedServer.serverIP
                    self.countryName.text = "\(connectedServer.country ?? "") , \(connectedServer.city ?? "")"
                    self.flag.image = UIImage.init(named: connectedServer.flag ?? "")
                    
                    self.selectedServer = connectedServer
                    self.connectionStatus.text = Titles.VPN_STATE_CONNECTED.rawValue.localiz().uppercased()
                    self.isVPNConnected = true
                    
                }
            }
        }
    }
    
    func checkConnectionOnstartup() -> Bool{
        let startupSwitch = UserDefaults.standard.value(forKey: User_Defaults.startupSwitch) as? Bool
        
        return startupSwitch ?? false
    }

    
    func getIPAddress() -> String {
        var publicIP = ""
        do {
            try publicIP = String(contentsOf: URL(string: "https://www.bluewindsolution.com/tools/getpublicip.php")!, encoding: String.Encoding.utf8)
            publicIP = publicIP.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        catch {
            print("Error: \(error)")
        }
        return publicIP
    }
    
    
    @objc func getTrafficStats() {
        if let session = self.providerManager.connection as? NETunnelProviderSession {
            do {
                try session.sendProviderMessage("SOME_STATIC_KEY".data(using: .utf8)!) { (data) in
                    // here you can unarchieve your data and get traffic stats as dict
                    
                    if let _ = data{
                        //                        let decodedString = String(data: data!, encoding: .utf8)!
                        //
                        //                        print("jsonString=\(decodedString)")
                        
                        if let bytesData = String(data: data!, encoding: . utf8){
                            //                            print("bytesData=\(bytesData)")
                            
                            let dict = self.convertToDictionary(text: bytesData)
                            
                            let bytesIn = dict?["bytesIn"] as! String
                            let bytesOut = dict?["bytesOut"] as! String
                            
                            self.dataRecieved.text = "\(Int(bytesIn)!/1000) KB"
                            self.dataSent.text = "\(Int(bytesOut)!/1000) KB"
                            //                            print("\(Int(bytesIn)!/1000000) MBs")
                            self.usageRemainingInMbs -= Double(bytesOut)!/1000000.00  + Double(bytesIn)!/1000000.00
//                            self.updateGaugeTimer()
                            
                        }
                    }
                    
                    
                    
                                        
                }
            } catch {
                // some error
            }
        }
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
            
            self.protocolNameLabel.setTitle("\(Titles.PROTOCOL.rawValue.localiz()): \(Titles.AUTOMATIC.rawValue.localiz())", for: .normal)
            return
        }
        
        self.protocolNameLabel.setTitle("\(Titles.PROTOCOL.rawValue.localiz()): OpenVPN - \(selectedProto.uppercased())", for: .normal)
    }
    
    
    
    @IBAction func connectBtn(_ sender:UIButton){

        
//        if state == 0{
//
//            self.connecting()
//            self.state = 1
//        }
//        else if state == 1{
//
//            self.connected()
//            self.state = 2
//        }
//        else if state == 2{
//
//            self.disconnected()
//            self.state = 0
//        }
        self.connectVpn()

       
        
    }
    
    
    @IBAction func sideMenuBtn(_ sender:UIBarButtonItem){
        
        
        if let _ = getConnectedVpnData(){
            HelperFunc().showToast(message: Titles.DISCONNECT_VPN_TO_CHANGE_THE_LOCATION.rawValue.localiz(), controller: self)
            return
        }
        
        
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
        
//        var vc = DemoViewController()
//        if #available(iOSApplicationExtension 13.0, *) {
//            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DemoViewController") as! DemoViewController
//
//        } else {
//            vc = self.storyboard?.instantiateViewController(withIdentifier: "DemoViewController") as! DemoViewController
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        self.openSettingsScreen()
       
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
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}


//VPN
extension VPNViewController{
    
    
    func connectVpn(){
        
//        self.stopTimer3()
//        self.stopTimer4()
        if isVPNConnected == true {
            
            self.connectionStatus.text = Titles.VPN_STATE_DISCONNECTING.rawValue.localiz().uppercased()
            self.connectBtn.isEnabled = false
            self.providerManager.connection.stopVPNTunnel()
//            self.disconnected()
            
//            let alert = UIAlertController(title: "Cancel Confirmation", message: "Disconnect the connected VPN cancel the connection attempt?", preferredStyle: UIAlertController.Style.alert)
//
//            let disconnectAction = UIAlertAction(title: "DISCONNECT", style: UIAlertAction.Style.destructive) { _ in
//                self.providerManager.connection.stopVPNTunnel()
//                self.disconnected()
//            }
//
//            let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
//
//            // relate actions to controllers
//            alert.addAction(disconnectAction)
//
//            alert.addAction(dismiss)
//
//            present(alert, animated: true, completion: nil)
        }
        else{
            
//            let otherAlert = UIAlertController(title: "IronSocket VPN", message: Titles.DO_YOU_WANT_TO_CONNECT_TO_VPN.rawValue.localiz(), preferredStyle: UIAlertController.Style.alert)
//
//            let connectAction = UIAlertAction(title: Titles.YES.rawValue.localiz(), style: UIAlertAction.Style.default) { _ in
//
//
                
                let userCredentials = HelperFunc().getUserDefaultData(dec: UserCredentials.self, title: User_Defaults.userCredentials)
                let password = userCredentials?.password
                let username = userCredentials?.username
//                let password = self.userData?.password ?? ""
//                let username = self.userData?.username ?? ""
                self.loadProviderManager {

                    self.connectBtn.isEnabled = false
                    self.configureVPN(serverAddress: "", username: username!, password:password!)
                    self.connecting()
                    
                }
//
//            }
//
//            let dismiss = UIAlertAction(title: Titles.NO.rawValue.localiz(), style: UIAlertAction.Style.cancel, handler: nil)
//
//            // relate actions to controllers
//            otherAlert.addAction(connectAction)
//
//            otherAlert.addAction(dismiss)
//
//            present(otherAlert, animated: true, completion: nil)
            
            
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


        var selectedProto = UserDefaults.standard.value(forKey: User_Defaults.proto) as? String
        let selectedEncryption = UserDefaults.standard.value(forKey: User_Defaults.encryption) as? String
        
        if selectedProto == Proto_type.auto.rawValue{
            selectedProto = Proto_type.tcp.rawValue
        }
        
        if selectedEncryption == Encryption_type.auto.rawValue{
            selectedProto = Encryption_type.strong.rawValue
        }
        
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
            self.connectionStatus.text = Titles.VPN_STATE_CONNECTING.rawValue.localiz().uppercased()

            
            
            break
        case .connected:
            self.connectBtn.isEnabled = true
            isVPNConnected = true
            print("Connected...")
            self.connectionStatus.text = Titles.VPN_STATE_CONNECTED.rawValue.localiz().uppercased()

            self.connected()
            self.saveConnectedVpnData(connectedServer: self.selectedServer)
            
            break
        case .disconnecting:
            self.connectBtn.isEnabled = false
            print("Disconnecting...")
            self.connectionStatus.text = Titles.VPN_STATE_DISCONNECTING.rawValue.localiz().uppercased()
            break
        case .disconnected:
            self.connectBtn.isEnabled = true
            isVPNConnected = false
            print("Disconnected...")
            self.connectionStatus.text = Titles.VPN_STATE_DISCONNECTED.rawValue.localiz().uppercased()
            self.disconnected()
            self.deleteConnectedVpnData()
            
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
//        self.serverIP.text = server.serverIP
        self.countryName.text = "\(server.country ?? "") , \(server.city ?? "")"
//        self.cityName.text = "\(server.city ?? "")"
        self.flag.image = UIImage.init(named: server.flag ?? "")
        
        self.selectedServer = server
        
    }
    
    
}

extension VPNViewController:SettingServerListProtocol{
    
    func settingSelectServer(server: Server) {
        if isVPNConnected{
            self.providerManager.connection.stopVPNTunnel()
            self.stopCircularTimer()
            self.stopSignalTimer()
            self.stopTimerLabel()
        }
        
        self.selectedIP = "\(server.serverIP ?? "0")"//" \(server.serverPort ?? "0")"
//        self.serverIP.text = server.serverIP
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
            signal2.setImageTintColor(UIColor.lightGray)
            signal3.setImageTintColor(UIColor.lightGray)
            selectedSignal = 1
        case 1:
            signal1.setImageTintColor(UIColor.lightGray)
            signal2.setImageTintColor(UIColor.AntennaConnecting)
            signal3.setImageTintColor(UIColor.lightGray)
            selectedSignal = 2
        case 2:
            signal1.setImageTintColor(UIColor.lightGray)
            signal2.setImageTintColor(UIColor.lightGray)
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
        stopCircularTimer()
        stopSignalTimer()
        
        circularView.progressLayer.isHidden = false
        circularView.progressLayer.strokeColor = UIColor.AntennaConnecting.cgColor
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
        startTimerTrafficStats()
        
        self.serverIP.text = getIPAddress()
        
//        self.saveConnectedVpnData(connectedServer: self.selectedServer)
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
        
        self.serverIP.text = getIPAddress()
        
//        self.deleteConnectedVpnData()
    }
    
    
    func saveConnectedVpnData(connectedServer:Server){

        HelperFunc().saveUserDefaultData(data: connectedServer, title: User_Defaults.connectedServer)
    }
    
    func deleteConnectedVpnData(){

        HelperFunc().deleteUserDefaultData(title: User_Defaults.connectedServer)
    }
    
    func getConnectedVpnData() -> Server?{
        let connectedServer = HelperFunc().getUserDefaultData(dec: Server.self, title: User_Defaults.connectedServer)
        return connectedServer
    }
}
