//
//  BaseStoreTests.swift
//  BaseStoreTests
//
//  Created by Tomasz Kukułka on 22/02/2022.
//

import XCTest
import Hamcrest

@testable import BaseStore

private enum UserStoreTestKey: BaseStoreKey {
    case piValue
    
    var key: String {
        switch self {
        case .piValue: return "name"
        }
    }
}

private final class UserDefaultsMock: UserDefaults {
    
    private var store: [String: Any?] = [:]
    
    override func set(_ value: Any?, forKey defaultName: String) {
        store[defaultName] = value
    }
    
    override func object(forKey defaultName: String) -> Any? {
        return store[defaultName] as? Any
    }
    
    override func removeObject(forKey defaultName: String) {
        store.removeValue(forKey: defaultName)
    }
}

class BaseStoreTests: XCTestCase {
    
    private var mock: UserDefaultsMock!
    private var sut: UserStore!
    
    override func setUp() {
        super.setUp()
        
        mock = UserDefaultsMock()
        sut = UserStore(userDefaults: mock)
    }
    
    override func tearDown() {
        mock = nil
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    func test_settingAndRecievingValue() {
        let value = Double.pi
        
        sut.set(value: value, forKey: UserStoreTestKey.piValue)
        
        let recievedValue: Double? = sut.recieve(forKey: UserStoreTestKey.piValue)
        
        assertThat(value == recievedValue)
    }
    
    func test_removingValue() {
        let piValue = Double.pi
        
        sut.set(value: piValue, forKey: UserStoreTestKey.piValue)
        
        sut.remove(forKey: UserStoreTestKey.piValue)
        
        let recievedValue: Double? = sut.recieve(forKey: UserStoreTestKey.piValue)
        
        assertThat(recievedValue, nilValue())
    }
}
