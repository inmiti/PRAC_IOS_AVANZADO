//
//  SecureDataProvider.swift
//  AppInmaBautista
//
//  Created by ibautista on 21/10/23.
//

import Foundation
import KeychainSwift

// MARK: - Protocol -
protocol SecureDataProviderProtocol {
    func saveToken(token: String)
    func getToken() -> String?
    func deleteToken()
}
// MARK: - Keys -
enum KeyData {
    static let token = "KEY_TOKEN"
}

// MARK: - Class -
final class SecureDataProvider: SecureDataProviderProtocol {
    private var keychain = KeychainSwift()
    
    func saveToken(token: String){
        keychain.set(token, forKey: KeyData.token)
    }
    
    func getToken() -> String? {
        keychain.get(KeyData.token)
    }
    
    func deleteToken() {
        keychain.delete(KeyData.token)
    }
}
