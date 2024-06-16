//
//  SecureData.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 24/2/24.
//

import Foundation
import KeychainSwift


protocol SecureDataProtocol {
    func setToken(value: String)
    func getToken() -> String?
    func deleteToken()
    func saveSuperheroes(_ heroes: [Heroes])
}


class SecureDataKeychain: SecureDataProtocol {
    
    
    
    private let keychain = KeychainSwift()
    private let keyToken = "KCToken"
    func saveSuperheroes(_ heroes: [Heroes]) {
        let encoder = JSONEncoder()
           if let encoded = try? encoder.encode(heroes) {
               UserDefaults.standard.set(encoded, forKey: "SuperHeroes")
           }
       }
    func setToken(value: String) {
        keychain.set(value, forKey: keyToken)
    }
    
    func getToken() -> String? {
        keychain.get(keyToken)
        
    }
    
    func deleteToken() {
        keychain.delete(keyToken)
    }
}

// Implementación del SEcureDataProtocol con Userdefaults
// Se puede usar para Testing por ejemplo
class SecureDataUserDefaults: SecureDataProtocol {
    func saveSuperheroes(_ heroes: [Heroes]) {
        
    }
    
    
    private let userDefaults = UserDefaults.standard
    private let keyToken = "KCToken"
    
    func setToken(value: String) {
        userDefaults.setValue(value, forKey: keyToken)
    }
    
    func getToken() -> String? {
        userDefaults.value(forKey: keyToken) as? String
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: keyToken)
    }
}
