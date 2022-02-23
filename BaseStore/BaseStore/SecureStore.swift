//
//  SecureStore.swift
//  BaseStore
//
//  Created by Tomasz Kukułka on 23/02/2022.
//

import Foundation

final class SecureStore<KEY: BaseStoreKey>: BaseStore {
    
    typealias Key = KEY
    
    private let keychainManager: KeychainManager
    
    init(keychainManager: KeychainManager) {
        self.keychainManager = keychainManager
    }
    
    func set<T>(value: T, forKey key: KEY) {
        
    }
    
    func recieve<T>(forKey key: KEY) -> T? {
        return nil
    }
    
    func remove(forKey key: KEY) {
        
    }
}
