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
    case testValue
    
    var key: String {
        switch self {
        case .testValue: return "test_value"
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
    private var sut: UserStore<UserStoreTestKey>!
    
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
        let value: Int = 71
        
        sut.set(value: value, forKey: .testValue)
        
        let recievedValue: Int? = sut.recieve(forKey: .testValue)
        
        assertThat(value == recievedValue)
    }
    
    func test_updatingAndRecievingValue() {
        var value: Int = 45
        
        sut.set(value: value, forKey: .testValue)
        
        var recievedValue: Int? = sut.recieve(forKey: .testValue)
        
        value = 99
        
        sut.set(value: value, forKey: .testValue)
        
        recievedValue = sut.recieve(forKey: .testValue)
        
        assertThat(value == recievedValue)
    }
    
    func test_removingValue() {
        let piValue: Int = 88
        
        sut.set(value: piValue, forKey: .testValue)
        
        sut.remove(forKey: .testValue)
        
        let recievedValue: Int? = sut.recieve(forKey: .testValue)
        
        assertThat(recievedValue, nilValue())
    }
}
