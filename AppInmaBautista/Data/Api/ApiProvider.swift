//
//  ApiProvider.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import Foundation

// MARK: - Protocol -
protocol ApiProviderProtocol {
    func login(email: String,
               password: String,
               completion: @escaping(Result<String, NetworkErrors>) -> Void)
}

// MARK: - NetoworkErrors -
enum NetworkErrors: Error {
    case notFormedUrl
    case decodingFailed
    case unknownError
    case noData
    case statusCode(code: Int?)
}

class ApiProvider: ApiProviderProtocol {
    // MARK: - Properties -
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private let session: URLSession
    
    init(session:URLSession = .shared) {
        self.session = session
    }
    
    private enum PathAPI {
        static let login = "/api/auth/login"
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
    }

