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
    
    func set<T>(value: T, forKey key: Key) {
        var helper: T = value
        let data = Data(bytes: &helper, count: MemoryLayout.size(ofValue: helper))
        
        do {
            try keychainManager.save(passwordData: data, account: key.key)
        } catch KeychainError.duplicateItem {
            do {
                try keychainManager.update(passwordData: data, forAccount: key.key)
            } catch {
                assertionFailure()
            }
        } catch {
            assertionFailure()
        }
    }
    
    func recieve<T>(forKey key: Key) -> T? {
        var data: Data!

        do {
            data = try keychainManager.readPasswordData(forAccount: key.key)
        } catch KeychainError.itemNotFound {
            return nil
        } catch {
            assertionFailure()
        }
        
        let helper: T? = data.withUnsafeBytes {
            return $0.load(as: T.self)
        }
        
        return helper
    }
    
    func remove(forKey key: Key) {
        
    }
}
