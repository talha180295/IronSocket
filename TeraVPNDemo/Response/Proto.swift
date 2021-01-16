//
//  Proto.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 14/01/2021.
//  Copyright © 2021 abc. All rights reserved.
//

import Foundation

// MARK: - Proto
struct Proto: Codable {
    var tcp, udp: ProtoType?
}

// MARK: - TCP
struct ProtoType: Codable {
    var none, low, strong: [String]?
}
