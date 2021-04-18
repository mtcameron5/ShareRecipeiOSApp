//
//  CreateUserData.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/28/21.
//

import Foundation

final class CreateUserData: Codable {
    var id: UUID?
    var name: String
    var username: String
    var password: String?
    
    init(name: String, username: String, password: String) {
        self.name = name
        self.username = username
        self.password = password
    }
}
