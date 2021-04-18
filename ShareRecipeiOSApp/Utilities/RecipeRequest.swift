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
    
    func userLikesRecipe(userID: UUID, recipeID: UUID, token: String, completion: @escaping (Result<Int, ResourceRequestError>) -> Void) {
        let likeRecipeRequestString = "http://localhost:8080/api/users/\(userID)/recipes/\(recipeID)/likes/"
        guard let likeRecipeURL = URL(string: likeRecipeRequestString) else {
            fatalError("Unable to create URL")
        }
        print(token)
        var likeRecipeRequest = URLRequest(url: likeRecipeURL)

        likeRecipeRequest.httpMethod = "POST"
        likeRecipeRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: likeRecipeRequest) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            if httpResponse.statusCode == 201 {
                completion(.success(httpResponse.statusCode))
            } else {
                print("Bad response", httpResponse.statusCode)
                completion(.failure(.badResponse))
            }
        }
            
        dataTask.resume()

    }
    
    func userUnlikesRecipe(userID: UUID, recipeID: UUID, token: String, completion: @escaping (Result<Int, ResourceRequestError>) -> Void) {
        let unlikeRecipeRequestString = "http://localhost:8080/api/users/\(userID)/recipes/\(recipeID)/likes/"
        guard let unlikeRecipeURL = URL(string: unlikeRecipeRequestString) else {
            fatalError("Unable to create URL")
        }
        var unlikeRecipeRequest = URLRequest(url: unlikeRecipeURL)
        unlikeRecipeRequest.httpMethod = "DELETE"
        unlikeRecipeRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: unlikeRecipeRequest) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            if httpResponse.statusCode == 204 {
                completion(.success(httpResponse.statusCode))
            } else {
                print("Bad response", httpResponse.statusCode)
                completion(.failure(.badResponse))
            }
        }
        dataTask.resume()
        

    }
    
    
    func getNumberOfLikes(completion: @escaping (Result<Int, ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("likes")
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let likesCount = try JSONDecoder().decode(Int.self, from: jsonData)
                completion(.success(likesCount))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
    
    func update(with updateData: CreateRecipeData, completion: @escaping (Result<Recipe, ResourceRequestError>) -> Void) {
        do {
            guard let token = Auth().token else {
                Auth().logout()
                completion(.failure(.tokenError))
                return
            }
            
            var urlRequest = URLRequest(url: resource)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try JSONEncoder().encode(updateData)
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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

}

