//
//  User.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import Foundation

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String
    var recipeCurrentlyWorkingOn: Recipe?
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}
