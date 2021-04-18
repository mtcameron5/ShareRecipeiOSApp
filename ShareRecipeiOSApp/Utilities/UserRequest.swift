//
//  UserRequest.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 4/8/21.
//

import Foundation

struct UserRequest {
    var resource: URL
    
    init() {
        let resourceString = "http://localhost:8080/api/users"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to create URL")
        }
        self.resource = resourceURL
    }
    
     func getUser(tokenID: String, completion: @escaping (Result<User, ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("token").appendingPathComponent(tokenID)
        print(url)
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
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
    
    func getLikedRecipes(userID: UUID, completion: @escaping (Result<[Recipe], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("\(userID)").appendingPathComponent("recipes").appendingPathComponent("likes")
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: jsonData)
                completion(.success(recipes))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
    func getCreatedRecipes(userID: UUID, completion: @escaping (Result<[Recipe], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("\(userID)").appendingPathComponent("recipes")
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: jsonData)
                completion(.success(recipes))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
    func getStartedRecipes(userID: UUID, completion: @escaping (Result<[Recipe], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("\(userID)").appendingPathComponent("recipes").appendingPathComponent("started")
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: jsonData)
                completion(.success(recipes))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
    func getFinishedRecipes(userID: UUID, completion: @escaping (Result<[Recipe], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("\(userID)").appendingPathComponent("recipes").appendingPathComponent("finished")
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: jsonData)
                completion(.success(recipes))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
    func getFollowedUsers(userID: UUID, completion: @escaping (Result<[User], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("connections").appendingPathComponent("\(userID)").appendingPathComponent("follows")
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([User].self, from: jsonData)
                completion(.success(recipes))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
}
