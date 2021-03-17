//
//  RecipeRequest.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import Foundation

struct RecipeRequest {
    let resource: URL
  
    init(recipeID: UUID) {
        let resourceString = "http://localhost:8080/api/recipes/\(recipeID)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
    
    func getUser(completion: @escaping (Result<User, ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("user")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                completion(.success(user))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }
        dataTask.resume()
    }
    
    func update(with updateData: CreateRecipeData, completion: @escaping (Result<Recipe, ResourceRequestError>) -> Void) {
        do {
            var urlRequest = URLRequest(url: resource)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try JSONEncoder().encode(updateData)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let recipe = try JSONDecoder().decode(Recipe.self, from: jsonData)
                    completion(.success(recipe))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingError))
        }
    }

    func delete() {
        var urlRequest = URLRequest(url: resource)
        urlRequest.httpMethod = "DELETE"
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
    }
}

