//
//  SideMenuViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 17/09/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import SwiftyPing

protocol ServerListProtocol {
    func selectServer(server:Server)
}

class LocationViewController: UIViewController {
    
    @IBOutlet weak var serverNameTbl:UITableView!
    
    var serverList = [Server]()
    var serverListUnsorted = [Server]()
    var delegate:ServerListProtocol?
//    var pingList = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverListUnsorted = serverList
        let ipList = serverList.map{ $0.serverIP ?? "" }
        checkPing(host: ipList)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        HelperFunc().registerTableCell(tableView: serverNameTbl, nibName: "MenuCell", identifier: "MenuCell")
        serverNameTbl.delegate = self
        serverNameTbl.dataSource = self
        setUpNavBar()
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        setSelectedLocation()
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        setSelectedLocation()
    }
    func setUpNavBar(){
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.flag.image = UIImage.init(named: serverList[indexPath.item].flag ?? "")
        cell.countryName.text = serverList[indexPath.item].country
        cell.cityName.text = serverList[indexPath.item].city
//        cell.time.text = "\(serverList[indexPath.item].ping)ms"
        
        let duration = serverList[indexPath.item].ping ?? 0
        cell.time.text = "\(duration)ms"
        
        if duration > 150 {
            cell.time.textColor = .red
        }
        else if duration > 100 && duration < 150 {
            cell.time.textColor = .yellow
        }
        else if duration < 100  {
            cell.time.textColor = .green
        }
//        if self.pingList.count > 0{
//            let duration = serverList[indexPath.item].ping
//            cell.time.text = "\(duration)ms"
//
//            if duration > 150 {
//                cell.time.textColor = .red
//            }
//            else if duration > 100 && duration < 150 {
//                cell.time.textColor = .yellow
//            }
//            else if duration < 100  {
//                cell.time.textColor = .green
//            }
//        }
            
        if indexPath.item == 0{
            cell.roundedCorners(corners: [.topLeft,.topRight], radius: 10)
            cell.layer.masksToBounds = false
        }
        if indexPath.item == serverList.count-1{
            cell.roundedCorners(corners: [.bottomLeft,.bottomRight], radius: 10)
            cell.layer.masksToBounds = false
        }
            
        let favServers = UserDefaults.standard.value(forKey: User_Defaults.favServers) as? [String]
        for item in favServers ?? []{
            if item == serverList[indexPath.item].country{
                cell.star.isSelected = true
            }
//            else{
//                cell.star.isSelected = false
//            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.selectServer(server: serverList[indexPath.item])
        //        var varr = [String : Any]()
        do{
            let varr = try serverList[indexPath.row].asDictionary()
            
            
            UserDefaults.standard.set(varr, forKey: User_Defaults.selectServer)
//            UserDefaults.standard.set(indexPath.row, forKey: "selectIndex")
            UserDefaults.standard.set(serverList[indexPath.row].serverIP, forKey: User_Defaults.selectIp)
            UserDefaults.standard.synchronize()
            
            print(UserDefaults.standard.value(forKey: User_Defaults.selectServer) as Any)
            
            //        let ViewCont =   self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainController
            //        self.navigationController?.pushViewController(ViewCont, animated: false)
        }
        catch{
            
        }
        //        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setSelectedLocation(){
        let selectedIp  = UserDefaults.standard.string(forKey: User_Defaults.selectIp) ?? self.serverListUnsorted.first?.serverIP
        let index = self.serverList.firstIndex{$0.serverIP == selectedIp}!
//        let index =  UserDefaults.standard.integer(forKey: "selectIndex")
        let indexPath = IndexPath(row: index, section: 0)
        let cell = serverNameTbl.cellForRow(at: indexPath) as! MenuCell
        cell.backgroundColor = UIColor.themeBlue
    }
    
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}



extension LocationViewController {
    
    func checkPing(host:[String]){
      
        
        // Ping indefinitely
//        let pinger = try? SwiftyPing(host: "1.1.1.1", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
//        pinger?.observer = { (response) in
//            let duration = response.duration
//            print(duration)
//        }
//        try? pinger?.startPinging()

//        // Ping once
//        for item in host{
//            let once = try? SwiftyPing(host: item, configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
//            once?.observer = { (response) in
//                let duration = response.duration
//                let ms = Int((duration ?? 0.0) * 1000.00)
//                self.pingList.append(ms)
//                print(ms)
//                if host.last == item{
//                    self.serverNameTbl.reloadData()
//                }
//            }
//            once?.targetCount = 1
//            try? once?.startPinging()
//        }

        
        // Ping once
        for (index,item) in host.enumerated(){
            let once = try? SwiftyPing(host: item, configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
            once?.observer = { (response) in
                let duration = response.duration
                let ms = Int((duration ?? 0.0) * 1000.00)
//                self.pingList.append(ms)
                self.serverList[index].ping = ms
                print("\(item) = \(ms)")
                if host.last == item{
//                    self.serverList[index].ping = Int.random(in: 1..<200)
//                    self.self.serverList = self.serverList.sorted { (item1, item2) -> Bool in
//                        if item1.ping ?? 0 < item2.ping ?? 0{
//                            return true
//                        }
//                        return false
//                    }
                    self.serverNameTbl.reloadData()
                }
            }
            once?.targetCount = 1
            try? once?.startPinging()
        }

        
    }
}
