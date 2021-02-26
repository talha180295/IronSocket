//
//  AppConstants.swift
//  Bidkum
//
//  Created by dev on 16/02/2020.
//  Copyright © 2020 bidkum. All rights reserved.
//

import Foundation
import UIKit

struct User_Defaults {
    static let user = "User"
    static let usage = "usage"
    static let userCredentials = "UserCredentials"
    static let adBlocker = "adBlocker"
    static let proto = "proto"
    static let encryption = "encryption"
    static let selectIp = "selectIp"
    static let selectServer = "selectServer"
    static let favServers = "favServers"
}

class AppConstants {
        
    static let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)    
    
    struct API {
        static let BASE_URL = "https://cloud.teravpn.com/api/app/"
        
    }

}



enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}



enum Proto_type : String{
    case auto = "Automatic"
    case tcp
    case udp
}

enum Encryption_type : String{ 
    case auto
    case strong
    case low
    case none
}
