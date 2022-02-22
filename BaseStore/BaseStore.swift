//
//  BaseStore.swift
//  BaseStore
//
//  Created by Tomasz Kukułka on 22/02/2022.
//

import Foundation

protocol BaseStoreKey {
    var key: String { get }
}

enum UserStoreKey: BaseStoreKey {
    var key: String {
        switch self {
        default: return ""
        }
    }
}

protocol BaseStore {
    func set<T>(value: T, forKey key: BaseStoreKey)
    func recieve<T>(forKey key: BaseStoreKey) -> T?
    func remove(forKey key: BaseStoreKey)
}

final class UserStore: BaseStore {
        
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set<T>(value: T, forKey key: BaseStoreKey) {
        userDefaults.set(value, forKey: key.key)
    }
    
    func recieve<T>(forKey key: BaseStoreKey) -> T? {
        return userDefaults.object(forKey: key.key) as? T
    }
    
    func remove(forKey key: BaseStoreKey) {
        userDefaults.removeObject(forKey: key.key)
    }
}
