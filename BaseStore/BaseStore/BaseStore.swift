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

protocol BaseStore {
    associatedtype Key: BaseStoreKey
    func set<T>(value: T, forKey key: Key)
    func recieve<T>(forKey key: Key) -> T?
    func remove(forKey key: Key)
}
