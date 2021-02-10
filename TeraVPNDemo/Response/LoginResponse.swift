// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginResponse = try? newJSONDecoder().decode(LoginResponse.self, from: jsonData)

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    var success, name, username, password: String?
    var nextdue, curloc, query, package: String?
    var server: [Server]?
    var adblocker, email: String?
    var planID: Int?
    var help: [Help]?

    enum CodingKeys: String, CodingKey {
        case success, name, username, password, nextdue, curloc, query, package, server, adblocker, email, help
        case planID = "plan_id"
    }
}

// MARK: - Server
struct Server: Codable {
    var serverIP, serverPort, country, city: String?
    var flag, type: String?
    var ping: Int?
    enum CodingKeys: String, CodingKey {
        case serverIP = "server_ip"
        case serverPort = "server_port"
        case country, city, flag, type
    }
}

// MARK: - Help
struct Help: Codable {
    var id, title, details, device: String?
}

