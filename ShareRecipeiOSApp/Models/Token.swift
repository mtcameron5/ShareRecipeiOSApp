//
//  Token.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/28/21.
//

import Foundation

final class Token: Codable {
    var id: UUID?
    var value: String
    
    init(value: String) {
        self.value = value
    }
}
