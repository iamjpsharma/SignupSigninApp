//
//  KeyChainHelper.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 11/02/25.
//

import Security
import Foundation

class KeyChainHelper {
    
    func saveToKeychain(stringData: String, forKey key: String) -> Bool {
        // Convert the String to Data
        guard let fetchedData = stringData.data(using: .utf8) else {
            return false
        }
        
        // Create a query dictionary
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: fetchedData
        ]
        
        // Delete any existing item before saving
        SecItemDelete(query as CFDictionary)
        
        // Add the new item to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getFromKeychain(forKey key: String) -> String? {
        // Create a query dictionary
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        // Retrieve the item from the Keychain
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // Check if the item was found and convert it to a string
        if status == errSecSuccess, let data = dataTypeRef as? Data, let stringData = String(data: data, encoding: .utf8) {
            return stringData
        } else {
            return nil
        }
    }
}
