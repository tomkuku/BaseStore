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
    
    func save(passwordData data: Data, account: String) throws {
        let query = [
            kSecAttrAccount: account,
            kSecClass: kSecClassInternetPassword,
            kSecValueData: data,
            kSecReturnAttributes: true
        ] as CFDictionary
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func readPasswordData(forAccount account: String) throws -> Data {
        throw KeychainError.itemNotFound
    }
}
