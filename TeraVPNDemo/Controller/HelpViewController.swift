//
//  HelpViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 08/12/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import Alamofire

class HelpViewController: UIViewController {
    
    
    @IBOutlet weak var helpTableView:UITableView!
    
    //    var userData: LoginResponse!
    var content = [Help]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        self.content = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)?.help ?? [Help]()
        //        self.content = self.userData.help ?? [Help]()
        //let userData = HelperFunc().getUserDefaultData(dec: LoginResponse.self, title: User_Defaults.user)
        
        HelperFunc().registerTableCell(tableView: helpTableView, nibName: "HelpCell", identifier: "HelpCell")
        helpTableView.delegate = self
        helpTableView.dataSource = self
        
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

extension HelpViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCell", for: indexPath) as! HelpCell
        
        //        cell.flag.image = UIImage.init(named: serverList[indexPath.item].flag ?? "")
        cell.title.text = content[indexPath.item].title
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let progressQueue = DispatchQueue(label: "com.alamofire.progressQueue", qos: .utility)
//
//        Alamofire.download("https://httpbin.org/image/png")
//            .downloadProgress(queue: progressQueue) { progress in
//                print("Download Progress: \(progress.fractionCompleted)")
//
//            }
//            .responseData { response in
//                if let data = response.value {
//                    let image = UIImage(data: data)
//                }
//            }
        
        let speedTest = NetworkSpeedProvider()
        speedTest.test()
    }
}


class NetworkSpeedProvider: NSObject {
    
    var startTime = CFAbsoluteTime()
    var stopTime = CFAbsoluteTime()
    var bytesReceived: CGFloat = 0
    var speedTestCompletionHandler: ((_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void)? = nil
    
    func test() {
        
        testDownloadSpeed(withTimout: 5.0, completionHandler: {(_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void in
            print("%0.1f; error = \(megabytesPerSecond)")
        })
    }
}


extension NetworkSpeedProvider: URLSessionDataDelegate, URLSessionDelegate {
    
    
    func testDownloadSpeed(withTimout timeout: TimeInterval, completionHandler: @escaping (_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void) {
        
        
        
        // you set any relevant string with any file
        let urlForSpeedTest = URL(string: "http://ipv4.scaleway.testdebit.info/1G.iso")
        
        
        
        
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        speedTestCompletionHandler = completionHandler
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        guard let checkedUrl = urlForSpeedTest else { return }
        
        session.dataTask(with: checkedUrl).resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived += CGFloat(data.count)
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let elapsed = (stopTime - startTime) //as? CFAbsoluteTime
        let speed: CGFloat = elapsed != 0 ? bytesReceived / (CGFloat(CFAbsoluteTimeGetCurrent() - startTime)) / 1024.0 / 1024.0 : -1.0
        // treat timeout as no error (as we're testing speed, not worried about whether we got entire resource or not
        if error == nil || ((((error as NSError?)?.domain) == NSURLErrorDomain) && (error as NSError?)?.code == NSURLErrorTimedOut) {
            speedTestCompletionHandler?(speed, nil)
        }
        else {
            speedTestCompletionHandler?(speed, error)
        }
    }
}


