//
//  KeychainManager.swift
//  BaseStore
//
//  Created by Tomasz Kukułka on 22/02/2022.
//

import Foundation

enum KeychainError: Error, Equatable {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)
}

final class KeychainManager {
    
    // MARK: Save
    
    func save(passwordData data: Data, account: String) throws {
        let query = [
            kSecAttrAccount: account,
            kSecClass: kSecClassInternetPassword,
            kSecValueData: data
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
            
        } else if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    // MARK: Read
    
    func readPasswordData(forAccount account: String) throws -> Data {
        let query = [
            kSecAttrAccount: account,
            kSecClass: kSecClassInternetPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: kCFBooleanTrue!
        ] as CFDictionary
        
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query, &itemCopy)
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
            
        } else if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
        
        guard let password = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return password
    }
    
    // MARK: Update
    
    func update(passwordData: Data, forAccount account: String) throws {
        let query = [
            kSecAttrAccount: account,
            kSecClass: kSecClassInternetPassword
        ] as CFDictionary
        
        let attributes = [
            kSecValueData: passwordData
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attributes)
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
            
        } else if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    // MARK: Delete
    
    func deletePassword(forAccount account: String) throws {
        let query = [
            kSecAttrAccount: account,
            kSecClass: kSecClassInternetPassword
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
            
        } else if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
