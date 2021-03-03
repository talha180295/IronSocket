//
//  String+Localizable.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 28/02/2021.
//  Copyright © 2021 abc. All rights reserved.
//


import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String) -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}
