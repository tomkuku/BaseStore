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
    associatedtype Key: BaseStoreKey
    func set<T>(value: T, forKey key: Key)
    func recieve<T>(forKey key: Key) -> T?
    func remove(forKey key: Key)
}

final class UserStore<KEY: BaseStoreKey>: BaseStore {
    
    typealias Key = KEY
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set<T>(value: T, forKey key: Key) {
        userDefaults.set(value, forKey: key.key)
    }
    
    func recieve<T>(forKey key: Key) -> T? {
        return userDefaults.object(forKey: key.key) as? T
    }
    
    func remove(forKey key: Key) {
        userDefaults.removeObject(forKey: key.key)
    }
}
