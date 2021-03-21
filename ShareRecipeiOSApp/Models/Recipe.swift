//
//  Recipe.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import Foundation
import UIKit

final class Recipe: Codable {
    var id: UUID?
    var user: RecipeUser
    var name: String
    var ingredients: [String]
    var directions: [String]
    var servings: Int
    var cookTime: String
    var prepTime: String
//    var finishedProduct: UIImage?
    
    init(userID: UUID, name: String, ingredients: [String], directions: [String], servings: Int, cookTime: String, prepTime: String) {
        self.user = RecipeUser(id: userID)
        self.name = name
        self.ingredients = ingredients
        self.directions = directions
        self.servings = servings
        self.cookTime = cookTime
        self.prepTime = prepTime
//        self.finishedProduct = finishedProduct
    }
    
//    required init(from decoder: Decoder) throws {
//        <#statements#>
//    }
    
}


final class RecipeUser: Codable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}
