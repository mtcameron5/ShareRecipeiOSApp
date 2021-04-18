//
//  Category.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/28/21.
//

import Foundation

final class Category: Codable {
    var id: UUID?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
