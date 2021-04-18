//
//  CreateRecipeData.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//
import Foundation

struct CreateRecipeData: Codable {
    let userID: UUID
    var name: String
    var ingredients: [String]
    var directions: [String]
    var servings: Int
    var cookTime: String
    var prepTime: String
}

extension Recipe {
    func toCreateData() -> CreateRecipeData {
        return CreateRecipeData(userID: self.user.id, name: self.name, ingredients: self.ingredients, directions: self.directions, servings: self.servings, cookTime: self.cookTime, prepTime: self.prepTime)
    }
}
