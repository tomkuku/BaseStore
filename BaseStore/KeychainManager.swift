//
//  KeychainManager.swift
//  BaseStore
//
//  Created by Tomasz Kukułka on 22/02/2022.
//

import Foundation

enum KeychainManagerError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)
}

final class KeychainManager {
    
    func save(passwordData data: Data, account: String) throws {
        throw KeychainManagerError.itemNotFound
    }
}
