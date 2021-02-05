//
//  DemoViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 18/01/2021.
//  Copyright © 2021 abc. All rights reserved.
//

import UIKit
//import SpeedcheckerSDK

class DemoViewController: UIViewController {
    
    
}
//    @IBOutlet weak var containerView: UIView!
//
//    @IBOutlet weak var circularView: CircularProgressView!
//    @IBOutlet weak var signal1: UIButton!
//    @IBOutlet weak var signal2: UIButton!
//    @IBOutlet weak var signal3: UIButton!
//
//    var duration: TimeInterval!
//    var timer3:Timer!
//    var timer4:Timer!
//    var selectedSignal = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        circularView.center = view.center
////        circularView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
////        view.addSubview(circularView)
//        circularView.alpha = 0.5
//    }
//
//
//
//
//    func startTimer3() {
////        guard timer == nil else { return }
//        circularView.progressLayer.isHidden = false
//        circularProgrress()
//        timer3 =  Timer.scheduledTimer(
//            timeInterval: TimeInterval(3),
//            target      : self,
//            selector    : #selector(DemoViewController.circularProgrress),
//            userInfo    : nil,
//            repeats     : true)
//    }
//    func stopTimer3() {
//        timer3?.invalidate()
//        timer3 = nil
//        circularView.progressLayer.isHidden = true
//    }
//
//    @objc func circularProgrress() {
//        duration = 3    //Play with whatever value you want :]
//        circularView.progressAnimation(duration: duration)
//
//    }
//
//
//    func startTimer4() {
//        timer4 =  Timer.scheduledTimer(
//            timeInterval: TimeInterval(1),
//            target      : self,
//            selector    : #selector(DemoViewController.signalProgrress),
//            userInfo    : nil,
//            repeats     : true)
//    }
//
//    func stopTimer4() {
//        timer4?.invalidate()
//        timer4 = nil
//        signal1.setImageTintColor(.lightGray)
//        signal2.setImageTintColor(.lightGray)
//        signal3.setImageTintColor(.lightGray)
//        selectedSignal = 0
//    }
//
//
//    @objc func signalProgrress() {
//
//        switch selectedSignal {
//        case 0:
//            signal1.setImageTintColor(.green)
//            signal2.setImageTintColor(.lightGray)
//            signal3.setImageTintColor(.lightGray)
//            selectedSignal = 1
//        case 1:
//            signal1.setImageTintColor(.lightGray)
//            signal2.setImageTintColor(.green)
//            signal3.setImageTintColor(.lightGray)
//            selectedSignal = 2
//        case 2:
//            signal1.setImageTintColor(.lightGray)
//            signal2.setImageTintColor(.lightGray)
//            signal3.setImageTintColor(.green)
//            selectedSignal = 0
//        default:
//            break
//        }
//
//    }
//
//
//    @IBAction func btnclick(_sender:UIButton){
//
//        if timer3 == nil{
//            startTimer3()
//            startTimer4()
//        }
//        else{
//            stopTimer3()
//            stopTimer4()
//        }
//    }
//}
