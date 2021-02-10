//
//  SpeedTestViewController.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 10/02/2021.
//  Copyright © 2021 abc. All rights reserved.
//

import UIKit

class SpeedTestViewController: UIViewController, URLSessionDelegate, URLSessionDataDelegate {


    typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double? , _ error: Error?) -> Void

    var speedTestCompletionBlock : speedTestCompletionHandler?

    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        checkForSpeedTest()

    }

    func checkForSpeedTest() {

        testDownloadSpeedWithTimout(timeout: 7.0) { (speed, error) in
            print("Download Speed:", speed ?? "NA")
            print("Speed Test Error:", error ?? "NA")
        }

    }

    func testDownloadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) {

        guard let url = URL(string: "http://ipv4.scaleway.testdebit.info/1G.iso") else { return }

        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0

        speedTestCompletionBlock = withCompletionBlock

        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url).resume()

    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived! += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
        
        let elapsed = stopTime - startTime

        var downloadSpeed = Double(bytesReceived) / (elapsed)
        downloadSpeed = (downloadSpeed / (1024 * 1024)) * 8
        speedListener(speed: downloadSpeed)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        let elapsed = stopTime - startTime

        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            speedTestCompletionBlock?(nil, error)
            return
        }

//        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        var downloadSpeed = Double(bytesReceived) / (elapsed)
        downloadSpeed = (downloadSpeed / (1024 * 1024)) * 8
        speedTestCompletionBlock?(downloadSpeed, nil)

    }

    func speedListener(speed:Double){
        
        let formattedSpeed = String(format: "Speed: %.2f  MB/S", speed)
        print("\(formattedSpeed)")
    }
}
