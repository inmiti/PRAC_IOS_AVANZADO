//
//  ApiProvider.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//
import Foundation
import UIKit

// MARK: - Protocol -
protocol ApiProviderProtocol {
    func login(email: String,
               password: String,
               completion: @escaping(Result<String, NetworkErrors>) -> Void)
    func downloadImage(for url: URL,
                       completion: @escaping(Result< UIImage, NetworkErrors>) -> Void )
    func getHeroes(token: String?,
                   completion: @escaping(Result<Heroes, NetworkErrors>) -> Void)
    func getLocations(token: String?,
                      heroID: String?,
                      completion: @escaping(Result<Locations, NetworkErrors>) -> Void)
}

// MARK: - NetoworkErrors -
enum NetworkErrors: Error {
    case notFormedUrl
    case decodingFailed
    case unknownError
    case noData
    case statusCode(code: Int?)
    case notImage
    case notLogged
}

class ApiProvider: ApiProviderProtocol {

//    private var secureDataProvider: SecureDataProviderProtocol?
    
    // MARK: - Properties -
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private let session: URLSession
//    private let token: String? = secureDataProvider?.getToken()
    
    init(session:URLSession = .shared) {
        self.session = session
    }
    
    private enum PathAPI {
        static let login = "/api/auth/login"
        static let heroes = "/api/heros/all"
        static let locations = "/api/heros/locations"
    }
    
    // MARK: - Public functions -
    func login(email: String,
               password: String,
               completion: @escaping(Result<String, NetworkErrors>) -> Void) {
        var components = baseComponents
        components.path = PathAPI.login
        
        guard let url = components.url else {
            completion(.failure(NetworkErrors.notFormedUrl))
            return
        }
        
        let loginString = String(format: "%@:%@", email, password)
        guard let loginData = loginString.data(using: .utf8)?.base64EncodedString() else {
            completion(.failure(NetworkErrors.decodingFailed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkErrors.unknownError))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkErrors.noData))
                return
            }
            
            let httpUrlResponse = response as? HTTPURLResponse
            let statusCode = httpUrlResponse?.statusCode
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            completion(.success(token))
            
        }
        task.resume()
    }
    
    func downloadImage(for url: URL,
                       completion: @escaping(Result< UIImage, NetworkErrors>) -> Void ) {
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }
            guard let data else {
                completion(.failure(.noData))
                return
            }
            let httpUrlResponse = response as? HTTPURLResponse
            let statusCode = httpUrlResponse?.statusCode
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.notImage))
                return
            }
            completion(.success(image))
        }
        task.resume()
    }
    
    func getHeroes(token: String?,
                   completion: @escaping(Result<Heroes, NetworkErrors>) -> Void) {
        var components = baseComponents
        components.path = PathAPI.heroes
        
        guard let url = components.url else {
            completion(.failure(.notFormedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.notLogged))
            return}
         
        let jsonData: [String:Any] = ["name": ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)",
                         forHTTPHeaderField: "Authorization")
        request.httpBody = jsonParameters
        
        let task = session.dataTask(with: request) {data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let httpUrlResponse = response as? HTTPURLResponse
            let statusCode = httpUrlResponse?.statusCode
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            completion(.success(heroes))
            
        }
        task.resume()
    }
    
    func getLocations(token: String?,
                      heroID: String?,
                      completion: @escaping(Result<Locations, NetworkErrors>) -> Void) {
        var components = baseComponents
        components.path = PathAPI.locations
        
        guard let url = components.url else {
            completion(.failure(.notFormedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.notLogged))
            return}
        
        let jsonData: [String:Any] = ["id": heroID ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)",
                         forHTTPHeaderField: "Authorization")
        request.httpBody = jsonParameters
        
        let task = session.dataTask(with: request) {data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let httpUrlResponse = response as? HTTPURLResponse
            let statusCode = httpUrlResponse?.statusCode
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let locations = try? JSONDecoder().decode(Locations.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            completion(.success(locations))
            
        }
        task.resume()
    }
}

